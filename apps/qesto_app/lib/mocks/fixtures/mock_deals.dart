import '../../data/models/qesto_models.dart';

const mockCoupons = <Deal>[
  Deal(
    id: 'coupon-grocery',
    userId: 'demo-user',
    kind: DealKind.coupon,
    category: 'Супермаркеты',
    title: 'Скидка 15% в Перекрёстке',
    description: 'Экономьте на покупках продуктов каждый день.',
    visualKey: 'groceries',
    badge: '15%',
  ),
  Deal(
    id: 'coupon-restaurants',
    userId: 'demo-user',
    kind: DealKind.coupon,
    category: 'Рестораны',
    title: 'Кешбэк 20% в ресторанах',
    description: 'Повышенный кешбэк на любимые блюда в эти выходные.',
    visualKey: 'restaurant',
    badge: '20%',
  ),
  Deal(
    id: 'coupon-electronics',
    userId: 'demo-user',
    kind: DealKind.coupon,
    category: 'Электроника',
    title: 'Техника со скидкой 10 000 ₽',
    description: 'Обновите смартфон или ноутбук с выгодой до конца месяца.',
    visualKey: 'electronics',
  ),
  Deal(
    id: 'coupon-fashion',
    userId: 'demo-user',
    kind: DealKind.coupon,
    category: 'Одежда',
    title: 'Модный гардероб: −30%',
    description: 'Скидки на новую коллекцию одежды и аксессуаров.',
    visualKey: 'fashion',
    badge: '−30%',
  ),
  Deal(
    id: 'coupon-fuel',
    userId: 'demo-user',
    kind: DealKind.coupon,
    category: 'Авто',
    title: 'Заправка с бонусом',
    description: 'Получайте вдвое больше баллов на бонусную карту.',
    visualKey: 'fuel',
  ),
];

const mockPromotions = <Deal>[
  Deal(
    id: 'promotion-taxi',
    userId: 'demo-user',
    kind: DealKind.promotion,
    category: 'Транспорт',
    title: 'Три поездки со скидкой 25%',
    description: 'Предложение действует на поездки по городу до воскресенья.',
    visualKey: 'taxi',
    badge: '25%',
  ),
  Deal(
    id: 'promotion-delivery',
    userId: 'demo-user',
    kind: DealKind.promotion,
    category: 'Доставка',
    title: 'Бесплатная доставка продуктов',
    description: 'При заказе от 2 000 ₽ доставка будет бесплатной.',
    visualKey: 'delivery',
  ),
];

const mockTrackedProducts = <TrackedProduct>[
  TrackedProduct(
    id: 'tracked-headphones',
    userId: 'demo-user',
    title: 'Беспроводные наушники',
    currentPrice: 18990,
    currency: 'RUB',
    bestMarketplace: 'Яндекс Маркет',
    changePercent: -8.4,
    trackedStoresCount: 6,
    visualKey: 'electronics',
  ),
  TrackedProduct(
    id: 'tracked-coffee',
    userId: 'demo-user',
    title: 'Кофе в зёрнах, 1 кг',
    currentPrice: 1590,
    currency: 'RUB',
    bestMarketplace: 'Metro',
    changePercent: -12.0,
    trackedStoresCount: 4,
    visualKey: 'coffee',
  ),
];
