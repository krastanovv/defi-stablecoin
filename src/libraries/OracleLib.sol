//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library OracleLib {
    error OrcleLib__StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface chainlinkfeed)
        public
        view
        returns (uint256, int256, uint256, uint256, uint256)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updateAt, uint80 answeredInRound) =
            chainlinkfeed.latestRoundData();

        if (updateAt == 0 || answeredInRound < roundId) {
            revert OrcleLib__StalePrice();
        }
        uint256 secondsSince = block.timestamp - updateAt;
        if (secondsSince > TIMEOUT) revert OrcleLib__StalePrice();

        return (roundId, answer, startedAt, updateAt, answeredInRound);
    }

    function getTimeout(AggregatorV3Interface) public pure returns (uint256) {
        return TIMEOUT;
    }
}
