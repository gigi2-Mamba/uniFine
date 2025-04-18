// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2;

interface ImulSig {
    function getApplicationHash(
        address from,
        address to,
        bytes4 funcSig,
        uint256 _nonce
    ) external pure returns (bytes32);

    function validCall(
        address sender,
        address to,
        bytes4 sig,
        uint256 _nonce
    ) external;
}
