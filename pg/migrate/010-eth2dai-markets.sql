CREATE TYPE api.eth2dai_market AS (
  id         varchar,
  base       varchar,
  quote      varchar,
  buy_vol    numeric,
  sell_vol   numeric,
  price      numeric,
  high       numeric,
  low        numeric
);

COMMENT ON COLUMN api.eth2dai_market.id is 'Unique market symbol';
COMMENT ON COLUMN api.eth2dai_market.base is 'Base symbol';
COMMENT ON COLUMN api.eth2dai_market.quote is 'Quote symbol';
COMMENT ON COLUMN api.eth2dai_market.buy_vol is 'Total buy volume (base)';
COMMENT ON COLUMN api.eth2dai_market.sell_vol is 'Total sell volume (base)';
COMMENT ON COLUMN api.eth2dai_market.price is 'Volume weighted average sell price (quote)';
COMMENT ON COLUMN api.eth2dai_market.high is 'Max sell price';
COMMENT ON COLUMN api.eth2dai_market.low is 'Min buy price';

CREATE FUNCTION api.eth2dai_markets(period text DEFAULT '24 hours')
RETURNS SETOF api.eth2dai_market
AS
$$
  SELECT
    id,
    base,
    quote,
    buys.vol,
    sells.vol,
    (sells.price+buys.price) / 2,
    sells.high,
    buys.low
  FROM eth2dai.market m
  LEFT JOIN (
    SELECT
      lot_tkn,
      bid_tkn,
      SUM(lot_amt) as vol,
      SUM(price*bid_amt)/SUM(bid_amt) as price,
      MIN(price) AS low,
      MAX(price) AS high
    FROM api.eth2dai_trade
    WHERE time > now() - $1::interval
    GROUP BY lot_tkn, bid_tkn
  ) sells ON sells.lot_tkn = m.base AND sells.bid_tkn = m.quote
  LEFT JOIN (
    SELECT
      lot_tkn,
      bid_tkn,
      SUM(bid_amt) as vol,
      SUM(price*bid_amt)/SUM(bid_amt) as price,
      MIN(price) AS low,
      MAX(price) AS high
    FROM api.eth2dai_trade
    WHERE time > now() - $1::interval
    GROUP BY lot_tkn, bid_tkn
  ) buys ON buys.bid_tkn = m.base AND buys.lot_tkn = m.quote;
$$ LANGUAGE SQL stable;
