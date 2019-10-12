CREATE SCHEMA eth2dai;

CREATE TABLE eth2dai.offer (
  id         integer primary key,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal(28,18),
  bid_gem    character varying(66),
  bid_amt    decimal(28,18),
  removed    boolean,
  filled     boolean default false,
  killed     integer default 0,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null
);

CREATE INDEX eth2dai_offer_pair_index ON eth2dai.offer(pair);
CREATE INDEX eth2dai_offer_maker_index ON eth2dai.offer(maker);
CREATE INDEX eth2dai_offer_killed_index ON eth2dai.offer(killed);
CREATE INDEX eth2dai_offer_filled_index ON eth2dai.offer(filled);
CREATE INDEX eth2dai_offer_removed_index ON eth2dai.offer(removed);

CREATE TABLE eth2dai.trade (
  offer_id   integer,
  pair       character varying(66),
  maker      character varying(66),
  lot_gem    character varying(66),
  lot_amt    decimal(28,18),
  taker      character varying(66),
  bid_gem    character varying(66),
  bid_amt    decimal(28,18),
  removed    boolean,
  block      integer not null,
  time       timestamptz not null,
  tx         character varying(66) not null,
  idx        integer not null,
  CONSTRAINT unique_tx_idx UNIQUE(tx, idx)
);

CREATE INDEX eth2dai_trade_offer_id_index ON eth2dai.trade(offer_id);
CREATE INDEX eth2dai_trade_pair_index ON eth2dai.trade(pair);
CREATE INDEX eth2dai_trade_lot_gem_index ON eth2dai.trade(lot_gem);
CREATE INDEX eth2dai_trade_bid_gem_index ON eth2dai.trade(bid_gem);
CREATE INDEX eth2dai_trade_maker_index ON eth2dai.trade(maker);
CREATE INDEX eth2dai_trade_taker_index ON eth2dai.trade(taker);
CREATE INDEX eth2dai_trade_removed_index ON eth2dai.trade(removed);

CREATE TABLE eth2dai.market (
  id         character varying(10) primary key,
  base       character varying(10),
  quote      character varying(10)
);
