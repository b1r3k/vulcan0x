UPDATE eth2dai.offer
SET killed = ${block}, removed = ${removed}
WHERE id = ${id};
