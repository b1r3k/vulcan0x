CREATE FUNCTION api.eth2dai_offer_trades(offer api.eth2dai_offer) RETURNS setof api.eth2dai_trade AS $$
  SELECT *
  FROM api.eth2dai_trade
  WHERE eth2dai_trade.offer_id = offer.id
  ORDER BY eth2dai_trade.block DESC
$$ LANGUAGE SQL stable;

CREATE FUNCTION api.eth2dai_trade_offer(trade api.eth2dai_trade) RETURNS api.eth2dai_offer AS $$
  SELECT *
  FROM api.eth2dai_offer
  WHERE eth2dai_offer.id = trade.offer_id
  ORDER BY eth2dai_offer.id DESC
  LIMIT 1
$$ LANGUAGE SQL stable;
