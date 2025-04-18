pragma solidity >=0.6.6;

library whiteListAddress {
    // add whiteList
    function addWhiteListAddress(
        address[] storage whiteList,
        address temp
    ) internal {
        if (!isEligibleAddress(whiteList, temp)) {
            whiteList.push(temp); // 实际上只是单纯push()这种方法很少用
        }
    }

    function removeWhiteListAddress(
        address[] storage whiteList,
        address temp
    ) internal returns (bool) {
        uint256 len = whiteList.length;
        uint256 i = 0; // solidity的骚操作
        for (; i < len; i++) {
            if (whiteList[i] == temp) break;
        }
        if (i < len) {
            if (i != len - 1) {
                whiteList[i] = whiteList[len - 1];
            }
            whiteList.pop();
            return true;
        }
        return false;
    }

    function isEligibleAddress(
        address[] memory whiteList,
        address temp
    ) internal pure returns (bool) {
        uint256 len = whiteList.length;
        for (uint256 i = 0; i < len; i++) {
            if (whiteList[i] == temp) return true;
        }
        return false;
    }
}
