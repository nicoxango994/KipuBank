// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title KipuBank - Banco simple para depósitos y retiros de ETH
/// @author Nicolás Bianco
/// @notice Contrato educativo que permite a usuarios guardar ETH en bóvedas personales
/// @dev Se aplican patrones de seguridad: errores personalizados, checks-effects-interactions
contract KipuBank {

    // ==============================
    // ERRORS
    // ==============================
    error ExceedsBankCap(uint256 attempted, uint256 bankCap);
    error ExceedsWithdrawLimit(uint256 attempted, uint256 withdrawLimit);
    error InsufficientBalance(uint256 available, uint256 requested);

    // ==============================
    // EVENTS
    // ==============================
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // ==============================
    // STATE VARIABLES
    // ==============================
    uint256 public immutable bankCap;         // Límite máximo de ETH en el contrato
    uint256 public immutable withdrawLimit;   // Límite máximo por retiro
    uint256 public totalDeposits;             // Total de ETH depositados
    uint256 public depositCount;              // Cantidad de depósitos realizados
    uint256 public withdrawCount;             // Cantidad de retiros realizados

    mapping(address => uint256) private balances; // Saldo de cada usuario

    // ==============================
    // MODIFIERS
    // ==============================
    modifier underWithdrawLimit(uint256 amount) {
        if(amount > withdrawLimit) revert ExceedsWithdrawLimit(amount, withdrawLimit);
        _;
    }

    modifier underBankCap(uint256 amount) {
        if(totalDeposits + amount > bankCap) revert ExceedsBankCap(totalDeposits + amount, bankCap);
        _;
    }

    // ==============================
    // CONSTRUCTOR
    // ==============================
    constructor(uint256 _bankCap, uint256 _withdrawLimit) {
        bankCap = _bankCap;
        withdrawLimit = _withdrawLimit;
    }

    // ==============================
    // DEPOSIT FUNCTION
    // ==============================
    /// @notice Deposita ETH en la bóveda del usuario
    function deposit() external payable underBankCap(msg.value) {
        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        depositCount++;
        emit Deposit(msg.sender, msg.value);
    }

    // ==============================
    // WITHDRAW FUNCTION
    // ==============================
    /// @notice Retira ETH de la bóveda del usuario
    /// @param amount Cantidad a retirar
    function withdraw(uint256 amount) external underWithdrawLimit(amount) {
        uint256 userBalance = balances[msg.sender];
        if(amount > userBalance) revert InsufficientBalance(userBalance, amount);

        balances[msg.sender] -= amount;
        totalDeposits -= amount;
        withdrawCount++;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, amount);
    }

    // ==============================
    // VIEW FUNCTIONS
    // ==============================
    /// @notice Devuelve el saldo de un usuario
    function getBalance(address user) external view returns(uint256) {
        return balances[user];
    }
}

