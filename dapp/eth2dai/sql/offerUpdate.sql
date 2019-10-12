UPDATE eth2dai.offer
SET filled = ${filled}
WHERE id = ${id} AND filled != true;
