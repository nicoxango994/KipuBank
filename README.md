# KipuBank - Banco simple en Ethereum

## Descripción

KipuBank es un contrato inteligente educativo desarrollado en Solidity que permite a los usuarios **guardar ETH en bóvedas personales**, depositar y retirar fondos de manera segura.  
El contrato incluye mecanismos de seguridad como límites máximos de depósito y retiro, y chequeo de balances para evitar errores o abusos.

### Funcionalidades principales

- Depositar ETH en tu bóveda personal.
- Retirar ETH respetando el límite máximo de retiro.
- Consultar tu saldo.
- Contadores de depósitos y retiros.
- Emisión de eventos para registrar cada operación (`Deposit` y `Withdraw`).

---

## Despliegue

Para desplegar el contrato, necesitás:

1. Tener instalado **Remix** o un entorno de desarrollo Ethereum.
2. Seleccionar la versión de Solidity `0.8.26`.
3. Copiar el código del contrato `KipuBank.sol` en un archivo `.sol`.
4. Configurar los parámetros del constructor:

   ```solidity
   uint256 _bankCap = 100 ether;       // Límite total de ETH que el contrato puede almacenar
   uint256 _withdrawLimit = 5 ether;   // Límite máximo de retiro por transacción

Contrato: 0xe642da59f1839a4bdeedcf4be9791c5b44848870
