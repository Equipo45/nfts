//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract SimpleContract is ERC721,Ownable {

    //Precio de crear uno
    uint256 public mintPrice = 1 ether;
    //Total de nfts minteados
    uint256 public totalSupply;
    //Total de nfts posibles
    uint256 public maxSupply;
    //Mint enable
    //No define = false
    bool public isMintEnable;
    //Cuantos nfts a minteado cada wallet
    mapping(address => uint256) public mintedWallets;


    constructor () payable ERC721("Name","Symbol"){
        //Cambiar variables cuesta mucho gas , hay que tener cuidado
        //Las variables locales son mas baratas
        maxSupply = 3;
    }

    //onlyOwner viene de Ownable
    //Hace que solo el dueno del contrato puede ejecutar la funcion
    function toggleIsMintEnabled() external onlyOwner{
        isMintEnable = !isMintEnable;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    //Alfinal es un token no fungible
    function mint() external payable{
        //Reduce el coste y comprueba requesitos
        require(isMintEnable,"Mint not enabled");
        //Aqui limitamos el numero de tokens que podemos mintear
        require(mintedWallets[msg.sender] < 1 , "You cant mint more than one token");
        //Verificar que estes pagando el coste de minteo
        require(msg.value >= mintPrice,"Not enoughr ethereum");
        require(maxSupply > totalSupply,"Max supply achieve");

        mintedWallets[msg.sender]++;
        totalSupply++;

        uint256 tokenid = totalSupply;
        //Esta ultima funcion la heredamos de ERC721 , nos permite no repetir tokens y evitar filtraciones
        _safeMint(msg.sender , tokenid);
    }

}
