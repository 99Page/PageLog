# LiquidGlass

애플의 디자인 시스템 중, Liguid Glass에 대해서 정리한 문서

@Metadata {
    @CallToAction(purpose: link, url: https://developer.apple.com/videos/play/wwdc2025/219/)
}

## Overview

@Row {
    @Column {
        ![LiquidGlass](LiquidGlass)
    }
    
    @Column {
        iOS 26 버전부터 Liquid Glass 디자인 시스템이 적용됩니다. 현실 세계의 물리적 법칙을 적용해기 위해 뒤에 있는 뷰에 굴절+투명도를 줍니다. 
        
        이 시스템을 적용하기 위해 몇가지 지켜야할 원칙이 있습니다. 
    }
} 

## Principles

* Navigation Layer에만 사용합니다. 

네비게이션 레이어는 모든 뷰 계층 위에 존재하는 것을 말합니다. 예를 들어서 Navigation Bar, Tab bar, Sidebar, Toolbar 등이 있습니다. 

* Liquid Layer는 서로 겹치면 안됩니다.

두가지가 겹칠 경우 뷰 계층이 붕괴될 위험이 있습니다. 

* Clear 타입은 별도의 조건이 붙습니다. 

Liquid glass는 Regular, Clear 두가지 타입을 갖습니다. Clear 타입은 3가지 조건을 만족하는 경우에만 사용합니다. 

1.    이미지/미디어 중심의 콘텐츠 위에 놓이는 경우
2.    dimming layer가 콘텐츠를 해치지 않을 경우
3.    그 위에 표시되는 콘텐츠가 굵고 밝을 경우
