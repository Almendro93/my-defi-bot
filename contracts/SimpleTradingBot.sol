// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SimpleTradingBot {
    address public owner;
    IERC20 public tokenToTrade;
    uint256 public buyPrice;
    uint256 public sellPrice;

    event CompraRealizada(address comprador, uint256 cantidad, uint256 costo);
    event VentaRealizada(address vendedor, uint256 cantidad, uint256 ingresos);

    constructor(address _tokenToTrade, uint256 _buyPrice, uint256 _sellPrice) {
        owner = msg.sender;
        tokenToTrade = IERC20(_tokenToTrade);
        buyPrice = _buyPrice;
        sellPrice = _sellPrice;
    }

    modifier soloPropietario() {
        require(msg.sender == owner, "Solo el propietario puede llamar a esta función");
        _;
    }

    function comprar(uint256 cantidad) external soloPropietario {
        require(cantidad > 0, "La cantidad debe ser mayor que cero");

        uint256 costo = cantidad * buyPrice;

        // Verifica que el contrato tenga suficientes fondos para la compra
        require(tokenToTrade.balanceOf(address(this)) >= cantidad, "Fondos insuficientes en el contrato");

        // Transfiere tokens al comprador y recibe el pago
        require(tokenToTrade.transfer(msg.sender, cantidad), "Fallo al transferir tokens al comprador");
        require(tokenToTrade.transferFrom(msg.sender, address(this), costo), "Fallo al recibir el pago");

        emit CompraRealizada(msg.sender, cantidad, costo);
    }

    function vender(uint256 cantidad) external soloPropietario {
        require(cantidad > 0, "La cantidad debe ser mayor que cero");

        uint256 ingresos = cantidad * sellPrice;

        // Verifica que el contrato tenga suficientes tokens para la venta
        require(tokenToTrade.balanceOf(address(this)) >= cantidad, "Fondos insuficientes en el contrato");

        // Transfiere tokens al vendedor y recibe los ingresos
        require(tokenToTrade.transferFrom(address(this), msg.sender, cantidad), "Fallo al transferir tokens al vendedor");
        require(tokenToTrade.transfer(msg.sender, ingresos), "Fallo al recibir los ingresos");

        emit VentaRealizada(msg.sender, cantidad, ingresos);
    }
}
