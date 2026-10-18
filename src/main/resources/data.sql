-- 1. 配達エリアマスタ（架空住所ねじ込みテロを入り口で弾くための盾）
CREATE TABLE delivery_areas (
    area_id SERIAL PRIMARY KEY,
    town_name VARCHAR(100) NOT NULL UNIQUE,       -- 実在する自社配達エリアの町名（例: '大井', '広町'）
    zone_code VARCHAR(10) NOT NULL                -- 配送効率ソート順用の町名コード
);

-- 2. 総合ユーザーマスタ（顧客・スタッフ・オーナーが同居する器）
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,          -- ログインID
    password_hash VARCHAR(255) NOT NULL,          -- BCrypt等で暗号化されたパスワード
    role VARCHAR(20) NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'staff', 'owner', 'disabled')), -- 権限（disabledは一時停止中）
    full_name VARCHAR(100) NOT NULL,              -- 氏名（身元確認用）
    delivery_address VARCHAR(255) NOT NULL,       -- 配送先住所
    phone_number VARCHAR(20) NOT NULL,             -- 電話番号（重複チェック対象）
    penalty_balance INT NOT NULL DEFAULT 0 CHECK (penalty_balance >= 0), -- 未回収ペナルティ残高（5年間隔離保持）
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. 商品マスタ
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,           -- 商品名
    base_price INT NOT NULL CHECK (base_price > 0), -- 通常単価
    sale_price INT CHECK (sale_price > 0),         -- タイムセール価格（通常時はNULL）
    image_url VARCHAR(255) NOT NULL,               -- フリー素材の写真リンクURL
    preservation_days INT NOT NULL CHECK (preservation_days > 0), -- 商品固有の安心保証消費期限日数（イチゴなら3、お米なら30）
    is_perishable BOOLEAN NOT NULL DEFAULT TRUE,   -- 商品性質フラグ（TRUE:生鮮食品即廃棄 ／ FALSE:常温日用品2回目流用キープ）
    is_active BOOLEAN NOT NULL DEFAULT TRUE,       -- 公開フラグ（販売終了時はFALSEに切り替えて未来予約削除ブロックを回避）
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. 日付別ネットスーパー専用予約上限枠テーブル
CREATE TABLE product_daily_stocks (
    daily_stock_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    target_date DATE NOT NULL,                     -- 30日先までの日付
    net_stock INT NOT NULL DEFAULT 10 CHECK (net_stock >= 0), -- ネット専用予約枠（初期値一律10個、売切れ時は全自動カタログ非表示）
    UNIQUE(product_id, target_date)
);

-- 5. 注文メインテーブル
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    delivery_date DATE NOT NULL,                   -- お届け予定日（30日先制限、正月三が日自動スキップガード）
    total_amount INT NOT NULL DEFAULT 0,          -- 代引きお支払い総額（店舗責任欠品時にここから自動引き算減額）
    status VARCHAR(20) NOT NULL DEFAULT 'reserved' CHECK (status IN ('reserved', 'picking', 'delivering', 'completed', 'failed')), -- ステータス
    completed_at TIMESTAMP,                        -- 現地集金完了日時（日本の税法に厳密に準拠した引渡基準売上計上日）
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. 注文明細テーブル
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),    -- 注文数量
    price_at_purchase INT NOT NULL,                -- 契約価格保護スナップショット（その後の価格改定の影響を永久遮断）
    UNIQUE(order_id, product_id)
);

-- 7. 実在エリアマスタの初期データ挿入（新規登録時の前方一致検証用）
INSERT INTO delivery_areas (town_name, zone_code) VALUES 
('品川区大井', '001'),
('品川区広町', '002'),
('品川区西品川', '003');
