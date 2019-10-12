CREATE VIEW api.eth2dai_offer AS
SELECT
  o.id,
  m.id AS market,
  (
    CASE WHEN m.base = lot.symbol THEN 'ask'
    WHEN m.base = bid.symbol THEN 'bid'
    ELSE NULL
    END
  ) AS act,
  pair,
  maker,
  lot_gem,
  COALESCE(lot.symbol, 'XXX') AS lot_tkn,
  lot_amt,
  bid_gem,
  COALESCE(bid.symbol, 'XXX') AS bid_tkn,
  bid_amt,
  (
    CASE WHEN m.base = lot.symbol THEN bid_amt / lot_amt
    WHEN m.base = bid.symbol THEN lot_amt / bid_amt
    ELSE NULL
    END
  ) AS price,
  filled,
  killed,
  block,
  time,
  tx
FROM eth2dai.offer o
LEFT JOIN erc20.token lot
  ON lot.key = o.lot_gem
LEFT JOIN erc20.token bid
  ON bid.key = o.bid_gem
LEFT JOIN eth2dai.market m
  ON (lot.symbol = m.base AND bid.symbol = m.quote)
  OR (bid.symbol = m.base AND lot.symbol = m.quote);

COMMENT ON COLUMN api.eth2dai_offer.id is 'Unique offer identifier';
COMMENT ON COLUMN api.eth2dai_offer.market is 'Market base/quote symbol';
COMMENT ON COLUMN api.eth2dai_offer.pair is 'Trading pair hash';
COMMENT ON COLUMN api.eth2dai_offer.act is 'Market action (ask|bid)';
COMMENT ON COLUMN api.eth2dai_offer.maker is 'Offer creator address (msg.sender)';
COMMENT ON COLUMN api.eth2dai_offer.lot_gem is 'Lot token address';
COMMENT ON COLUMN api.eth2dai_offer.lot_tkn is 'Lot token symbol';
COMMENT ON COLUMN api.eth2dai_offer.lot_amt is 'Lot amount given';
COMMENT ON COLUMN api.eth2dai_offer.bid_gem is 'Bid token address';
COMMENT ON COLUMN api.eth2dai_offer.bid_tkn is 'Bid token symbol';
COMMENT ON COLUMN api.eth2dai_offer.bid_amt is 'Bid amount wanted';
COMMENT ON COLUMN api.eth2dai_offer.price is 'Market (quote) price';
COMMENT ON COLUMN api.eth2dai_offer.filled is 'True if the offer has been fully executed';
COMMENT ON COLUMN api.eth2dai_offer.killed is '0 if the offer is live or block height when killed';
COMMENT ON COLUMN api.eth2dai_offer.block is 'Block height';
COMMENT ON COLUMN api.eth2dai_offer.time is 'Block timestamp';
COMMENT ON COLUMN api.eth2dai_offer.tx is 'Transaction hash';

CREATE VIEW api.eth2dai_trade AS
SELECT
  offer_id,
  m.id AS market,
  (
    CASE WHEN m.base = lot.symbol THEN 'sell'
    WHEN m.base = bid.symbol THEN 'buy'
    ELSE NULL
    END
  ) AS act,
  pair,
  maker,
  taker,
  lot_gem,
  COALESCE(lot.symbol, 'XXX') AS lot_tkn,
  lot_amt,
  bid_gem,
  COALESCE(bid.symbol, 'XXX') AS bid_tkn,
  bid_amt,
  (
    CASE WHEN m.base = lot.symbol THEN bid_amt / lot_amt
    WHEN m.base = bid.symbol THEN lot_amt / bid_amt
    ELSE NULL
    END
  ) AS price,
  block,
  time,
  tx
FROM eth2dai.trade t
LEFT JOIN erc20.token lot
  ON lot.key = t.lot_gem
LEFT JOIN erc20.token bid
  ON bid.key = t.bid_gem
LEFT JOIN eth2dai.market m
  ON (lot.symbol = m.base AND bid.symbol = m.quote)
  OR (bid.symbol = m.base AND lot.symbol = m.quote);

COMMENT ON COLUMN api.eth2dai_trade.offer_id is 'Offer identifier';
COMMENT ON COLUMN api.eth2dai_trade.market is 'Market base/quote symbol';
COMMENT ON COLUMN api.eth2dai_trade.pair is 'Trading pair hash';
COMMENT ON COLUMN api.eth2dai_trade.act is 'Market action (buy|sell)';
COMMENT ON COLUMN api.eth2dai_trade.maker is 'Offer creator address';
COMMENT ON COLUMN api.eth2dai_trade.taker is 'Trade creator address (msg.sender)';
COMMENT ON COLUMN api.eth2dai_trade.lot_gem is 'Lot token address';
COMMENT ON COLUMN api.eth2dai_trade.lot_tkn is 'Lot token symbol';
COMMENT ON COLUMN api.eth2dai_trade.lot_amt is 'Lot amount given by maker';
COMMENT ON COLUMN api.eth2dai_trade.bid_gem is 'Bid token address';
COMMENT ON COLUMN api.eth2dai_trade.bid_tkn is 'Bid token symbol';
COMMENT ON COLUMN api.eth2dai_trade.bid_amt is 'Bid amount matched by taker';
COMMENT ON COLUMN api.eth2dai_trade.price is 'Market (quote) price';
COMMENT ON COLUMN api.eth2dai_trade.block is 'Block height';
COMMENT ON COLUMN api.eth2dai_trade.time is 'Block timestamp';
COMMENT ON COLUMN api.eth2dai_trade.tx is 'Transaction hash';
