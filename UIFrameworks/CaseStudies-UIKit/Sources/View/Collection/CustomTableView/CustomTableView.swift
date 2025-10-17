//
//  CustomTableView.swift
//  CaseStudies-UIKit
//
//  Created by 노우영 on 10/2/25.
//  Copyright © 2025 Page. All rights reserved.
//

import Foundation
import UIKit
import PageKit

final class CustomTableView<Cell: ConfigurableCell>: UIView {
    // 화면이 그려질 때 마다 지정한 메소드를 호출해주는 객체
    private var displayLink: CADisplayLink?
    
    private var stack = UIStackView()
    private let datas: [Cell.Data]
    
    private var currentVisibleIndexSet: Set<Int> = []
    
    private var didInitializeLayout = false
   
    private var gesture = Gesture()
    private var cellInfo = CellInfo()
    private var reuseQueue = Queue<Cell>()
    private(set) var contentOffset: CGPoint = .zero
    private lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    
    init(datas: [Cell.Data]) {
        self.datas = datas
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        measureExpectedCellSizeIfNeeded()
        
        // 화면에 표시할 셀 개수는 이 뷰의 실제 높이(bounds.height)에 따라 결정됩니다.
        // 따라서 레이아웃이 완료되어 크기가 확정된 이후 셀 수를 계산하고 스택에 추가합니다.
        if !didInitializeLayout {
            setCellCount()
            makeConstraints()
            didInitializeLayout = true
        }
        
        if currentVisibleIndexSet.isEmpty {
            updateVisibility()
        }
    }
    
    var estimatedContentHeight: CGFloat {
        guard let h = cellInfo.size?.height, !datas.isEmpty else { return 0 }
        let rows = CGFloat(datas.count)
        return rows * h + (rows - 1) * cellInfo.spacing
    }
    
    private var isContentOffsetOutOfBounds: Bool {
        isContentOffsetOutOfTopBounds || isContentOffsetOutOfBottomBounds
    }
    
    private var isContentOffsetOutOfTopBounds: Bool {
        currentVisibleIndexSet.sorted().first == 0 && contentOffset.y > 0
    }
    
    private var isContentOffsetOutOfBottomBounds:  Bool {
        currentVisibleIndexSet.sorted().last == datas.count - 1 && lastCellOffset > 0
    }
    
    private var hasExceededBounceThreshold: Bool {
        let threshold: CGFloat = 100
        let topOverscroll = max(0, contentOffset.y)
        let bottomOverscroll = max(0, lastCellOffset)
        
        let isAtTop = currentVisibleIndexSet.min() == 0
        let isAtBottom = currentVisibleIndexSet.max() == datas.count - 1
        
        return (isAtTop && topOverscroll > threshold) || (isAtBottom && bottomOverscroll > threshold)
    }
    
    private var lastCellOffset: CGFloat {
        guard let lastCell = stack.arrangedSubviews.last else { return 0 }
        
        let rectInSelf = lastCell.convert(lastCell.bounds, to: self)
        let viewport = self.bounds

        let offsetFromBottom = viewport.maxY - rectInSelf.maxY
        return offsetFromBottom
    }
    
    private func setCellCount() {
        guard let cellSize = cellInfo.size else { return }
        cellInfo.count = min(Int(self.bounds.height / cellSize.height) + 4, datas.count)
        cellInfo.minVisibleCount = Int(self.bounds.height / cellSize.height)
    }
    
    private func setupView() {
        addGestureRecognizer(pan)
        
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = cellInfo.spacing
        stack.isLayoutMarginsRelativeArrangement = true
    }
    
    private func measureExpectedCellSizeIfNeeded() {
        guard cellInfo.size == nil, bounds.width > 0 else { return }
        let availableWidth = bounds.width - 32
        let cell = Cell()

        // 크기 측정을 위한 뷰
        let container = UIView(frame: CGRect(x: 0, y: 0, width: availableWidth, height: 1))
        container.addSubview(cell)
        
        cell.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(container)
        }

        container.layoutIfNeeded()

        let target = CGSize(width: availableWidth, height: UIView.layoutFittingCompressedSize.height)
        let size = cell.systemLayoutSizeFitting(
            target,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        self.cellInfo.size = CGSize(width: availableWidth, height: size.height)
    }
    
    private func makeConstraints() {
        addSubview(stack)

        (0..<cellInfo.count).forEach { index in
            let cell = Cell()
            
            if index < datas.count {
                cell.configure(data: datas[index])
                cell.dataIndex = index
                cellInfo.bottomIndex = index
            }
            
            stack.addArrangedSubview(cell)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func applyTransform() {
        stack.transform = CGAffineTransform(translationX: 0, y: contentOffset.y)
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        updateScrollDirection(gesture.velocity(in: self))
        switch gesture.state {
        case .began:
            stopDecel()
        case .changed:
            gesture.setTranslation(.zero, in: self)
            let next = CGPoint(x: contentOffset.x - translation.x, y: contentOffset.y + translation.y)
            contentOffset = applyBounceIfNeeded(next)
            applyScrollChanges()
        case .ended, .cancelled:
            self.gesture.velocity = gesture.velocity(in: self)
            startDecel()
            
            if isContentOffsetOutOfBounds {
                bounce()
            }
        default: break
        }
    }
    
    private func updateScrollDirection(_ velocity: CGPoint) {
        if velocity.y < 0 {
            gesture.scrollDirection = .up
        } else if velocity.y > 0 {
            gesture.scrollDirection = .down
        }
        
        // velocity.y == 0 인 경우는 제스쳐 후 멈춘 상황. 현재 방향 유지
    }
    
    private func applyBounceIfNeeded(_ point: CGPoint) -> CGPoint {
        if isContentOffsetOutOfBounds {
            let rubberStepMax: CGFloat = 40
            let rubberSoftness: CGFloat = isContentOffsetOutOfBounds ? max(400, contentOffset.y) : max(400, lastCellOffset)
            
            let diff = point.y - contentOffset.y
            let s = abs(diff)
            let step = (s * rubberStepMax) / (s + rubberSoftness)
            let scaled = diff >= 0 ? step : -step
            return CGPoint(x: point.x, y: contentOffset.y + scaled)
        } else {
            return point
        }
    }
    
    // MARK: Deceleration
    private func startDecel() {
        stopDecel()
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateScrollOffset))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopDecel() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateScrollOffset(_ link: CADisplayLink) {
        if gesture.speed < 5 {
            stopDecel()
            return
        }
        
        if shouldTriggerBounce(speed: gesture.speed) {
            stopDecel()
            bounce()
            return
        }
       
        scrollWithDecleartion(link)
    }
    
    private func shouldTriggerBounce(speed: CGFloat) -> Bool {
        return hasExceededBounceThreshold || (isContentOffsetOutOfBounds && speed < 100)
    }
    
    private func scrollWithDecleartion(_ link: CADisplayLink) {
        let dt = CGFloat(link.targetTimestamp - link.timestamp) // 프레임 지속 시간
        
        gesture.velocity.x *= pow(gesture.decelerationRate, dt * 60)
        gesture.velocity.y *= pow(gesture.decelerationRate, dt * 60)

        let next = CGPoint(
            x: contentOffset.x + gesture.velocity.x * dt,
            y: contentOffset.y + gesture.velocity.y * dt
        )

        contentOffset = next
        applyScrollChanges()
    }
    
    private func bounce() {
        let targetY: CGFloat = {
            if isContentOffsetOutOfTopBounds { return 0 }
            if isContentOffsetOutOfBottomBounds {
                return (estimatedContentHeight <= bounds.height) ? 0 : (contentOffset.y + lastCellOffset)
            }
            return contentOffset.y
        }()
        
        contentOffset.y = targetY
        gesture.velocity = .zero // 바운스 후 감속에 의한 스크롤 제거
        
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.12,
                       options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            // offset은 변경되지만, 셀 재사용은 필요없는 상황
            self.applyTransform()
        }
    }
    
    enum Direction {
        case up
        case down
    }
    
    func applyScrollChanges() {
        applyTransform()
        updateVisibility()
//        reuseCell()
        enqueueCell()
        dequeueCell()
    }
}

// MARK: Reuse cell
extension CustomTableView {
    private func updateVisibility() {
        let viewport = self.bounds // 보이는 화면 영역
        
        var newSet: Set<Int> = []
        
        for subview in stack.arrangedSubviews {
            guard let cell = subview as? Cell else { continue }
            let rect = subview.convert(subview.bounds, to: self)
            let intersection = rect.intersection(viewport) // 겹치는 구간
            
            if !intersection.isNull && intersection.height > 0 {
                newSet.insert(cell.dataIndex)
            }
        }
        
        currentVisibleIndexSet = newSet
    }
    
    // 데이터를 순차적으로 enqueue 하면서, 예상 못한 순서로 enqueue 되는 것을 방지
    private func enqueueCell() {
        guard stack.arrangedSubviews.count > cellInfo.minVisibleCount else { return }
        
        for subview in stack.arrangedSubviews {
            guard let cell = subview as? Cell else { continue }
            
            switch gesture.scrollDirection {
            case .up:
                if cell.dataIndex == cellInfo.topIndex
                    && !currentVisibleIndexSet.contains(cellInfo.topIndex) {
                    enqueueWhenScrollUp(cell)
                    return
                }
            case .down:
                if cell.dataIndex == cellInfo.bottomIndex
                    && !currentVisibleIndexSet.contains(cellInfo.bottomIndex) {
                    enqueueWhenScrollDown(cell)
                    return
                }
            }
        }
    }
    
    private func enqueueWhenScrollDown(_ cell: Cell) {
        stack.removeArrangedSubview(cell)
        cell.removeFromSuperview()
        cell.prepareForReuse()
        reuseQueue.enqueue(cell)
        cellInfo.bottomIndex -= 1
    }
    
    private func enqueueWhenScrollUp(_ cell: Cell) {
        stack.removeArrangedSubview(cell)
        cell.removeFromSuperview()
        cell.prepareForReuse()
        reuseQueue.enqueue(cell)
        adjustContentOffsetWhenEnqueue(cell)
        cellInfo.topIndex += 1
    }
    
    private func adjustContentOffsetWhenEnqueue(_ cell: Cell) {
        switch gesture.scrollDirection {
        case .up:
            let h = cell.bounds.height + stack.spacing
            contentOffset.y += h
            applyTransform()
        case .down:
            break
        }
    }
    
    private func dequeueCell() {
        let sortedVisibleIndexes = currentVisibleIndexSet.sorted()
        switch gesture.scrollDirection {
        case .up:
            guard self.cellInfo.bottomIndex == sortedVisibleIndexes.last else { return }
            guard cellInfo.bottomIndex + 1 < datas.count else { return }
            guard let cell = reuseQueue.dequeue() else { return }
            
            cellInfo.bottomIndex += 1

            cell.dataIndex = cellInfo.bottomIndex
            cell.configure(data: datas[cellInfo.bottomIndex])
            stack.addArrangedSubview(cell)
        case .down:
            guard cellInfo.topIndex == sortedVisibleIndexes.first else { return }
            guard cellInfo.topIndex - 1 >= 0 else { return }
            guard let cell = reuseQueue.dequeue() else { return }
            
            cellInfo.topIndex -= 1

            cell.dataIndex = cellInfo.topIndex
            cell.configure(data: datas[cellInfo.topIndex])
            let h = cell.bounds.height + stack.spacing
            contentOffset.y -= h
            applyTransform()
            stack.insertArrangedSubview(cell, at: 0)
        }
    }
    
//    private func reuseCell() {
//        switch gesture.scrollDirection {
//        case .up:
//            guard self.cell.topIndex != currentVisibleIndexSet.sorted().first else { return }
//            guard let firstCell = stack.arrangedSubviews.first as? Cell else { return }
//            let nextIndex = self.cell.bottomIndex + 1
//            guard nextIndex < datas.count else { return }
//
//            let h = firstCell.bounds.height + stack.spacing
//
//            // 맨 위 셀 제거
//            stack.removeArrangedSubview(firstCell)
//            firstCell.removeFromSuperview()
//
//            // 오프셋 보정
//            contentOffset.y += h
//            
//            applyTransform()
//            updateVisibility()
//
//            // 맨 아래 새 셀 추가
//            self.cell.topIndex += 1
//            self.cell.bottomIndex = nextIndex
//            firstCell.dataIndex = self.cell.bottomIndex
//            firstCell.configure(data: datas[self.cell.bottomIndex])
//            stack.addArrangedSubview(firstCell)
//
//        case .down:
//            guard self.cell.bottomIndex != currentVisibleIndexSet.sorted().last else { return }
//            guard let lastCell = stack.arrangedSubviews.last as? Cell else { return }
//            let newTopIndex = self.cell.topIndex - 1
//            guard newTopIndex >= 0 else { return }
//
//            let h = lastCell.bounds.height + stack.spacing
//
//            // 맨 아래 셀 제거
//            stack.removeArrangedSubview(lastCell)
//            lastCell.removeFromSuperview()
//
//            // 오프셋 보정
//            contentOffset.y -= h
//            applyTransform()
//            updateVisibility()
//
//            // 맨 위 새 셀 추가
//            self.cell.topIndex = newTopIndex
//            self.cell.bottomIndex -= 1
//            lastCell.dataIndex = self.cell.topIndex
//            lastCell.configure(data: datas[self.cell.topIndex])
//            stack.insertArrangedSubview(lastCell, at: 0)
//        }
//    }
}

extension CustomTableView {
    struct Gesture {
        var scrollDirection: Direction = .up
        var velocity: CGPoint = .zero
        var decelerationRate: CGFloat = 0.95 // 0~1, 1에 가까울수록 오래 감속
        
        var speed: CGFloat {
            hypot(velocity.x, velocity.y)
        }
    }
    
    struct CellInfo {
        var topIndex = 0
        var bottomIndex = -1
        var count = 5 // 임시 값
        var minVisibleCount = 1 // 바운스 과정에서 의도치 않은 셀 enqueue 방지
        var size: CGSize?
        var spacing: CGFloat = 10
        
        var isBottomIndexIntialized: Bool {
            bottomIndex != -1
        }
        
        var dataIndexRange: ClosedRange<Int> {
            topIndex...bottomIndex
        }
    }
}

class IntCell: UILabel, ConfigurableCell {
    var dataIndex: Int = -1
    
    required init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.randomPastelColor
    }
    
    func configure(data: Int) {
        text = "\(data)"
    }
    
    typealias Data = Int
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 95)
    }
}


@available(iOS 18.0, *)
#Preview {
    CustomTableView<IntCell>(
        datas: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    )
}

