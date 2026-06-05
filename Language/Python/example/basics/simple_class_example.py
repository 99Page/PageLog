from dataclasses import dataclass

@dataclass
class Item:
    id: int
    count: int

    def total_price(self, price_per_unit: int) -> int:
        return self.count * price_per_unit

    def add_count(self, amount: int):
        self.count += amount