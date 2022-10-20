// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./ColorGenerator.sol";

contract Game2048 is ERC721Enumerable {
    using Strings for uint256;
    uint256 public maxSupply = 50;

    constructor() ERC721("NFTGame2048", "G2048") {}

    function mint() public {
        uint256 supply = totalSupply();
        require(supply + 1 <= maxSupply);

        _safeMint(msg.sender, supply + 1);
    }

    function generateSVG(address _address) internal pure returns(string memory) {
        return Base64.encode(bytes(abi.encodePacked(
            '<svg width="512" height="512" viewBox="0 0 512 512" fill="none" xmlns="http://www.w3.org/2000/svg">',
            '<path d="M97 119C97 86.4152 123.415 60 156 60H356C388.585 60 415 86.4152 415 119V319C415 351.585 388.585 378 356 378H156C123.415 378 97 351.585 97 319V119Z" fill="#',ColorGenerator.getColors(_address),'"/>',
            '<text style="fill: black; font-family: Arial, sans-serif; font-size: 120px;" dominant-baseline="middle" text-anchor="middle" x="50%" y="45%">2048</text>',
            '<text style="fill: black; font-family: Arial, sans-serif; font-size: 30px;" dominant-baseline="middle" text-anchor="middle" x="50%" y="86%">OPEN TO PLAY THE GAME</text>',
            '</svg>'
            )));
    }

    function generateHTML() internal pure returns(string memory) {
        return Base64.encode(bytes(abi.encodePacked(
            '<html> <head> <style type="text/css"> *{ margin: 0px; padding: 0px; outline: 0px; border: 0px; box-sizing: border-box; } html, body{ width: 100%; height: 100%; } body{ display: flex; justify-content: center; align-items: center; } .content-wrapper{ height: 80vh; width: 80vh; /*border: 1px solid black;*/ display: flex; /*border: 1px solid black;*/ flex-direction: column; } .row{ height: 25%; display: flex; /*border-top: 1px solid black;*/ display: flex; justify-content: center; background-color: #BBAC9D; } .sq{ font-size: 50px; height: 85%; width: 85%; /*border: 1px solid black;*/ display: flex; justify-content: center; -ms-align-items: center; align-items: center; transition: width 0.5s ease-in-out, height 0.5s ease-in-out; background-color: #CCC0B0; border-radius: 10px; } .row:last-child{ /*border-bottom: 1px solid black;*/ } .column{ display: flex; /*border-left: 1px solid black;*/ width: 25%; justify-content: center; align-items: center; } .column:last-child{ /*border-right: 1px solid black;*/ } </style> </head> <body> <section class="content-wrapper"> <div class="row"> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> </div> <div class="row"> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> </div> <div class="row"> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> </div> <div class="row"> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> <div class="column"> <div class="sq"></div> </div> </div> </section> <script> var rowLength = 4, columnLength = 4; var rows = document.getElementsByClassName("row"); var cells = [ [], [], [], [] ]; cellObjs = [ [], [], [], [] ]; var score = 0; var clrSch = { default: "#CCC0B0", 2 : "#EEE4D8", 4 : "#ECE2C4", 8 : "#F8AF6C", 16 : "#F4863C", 32 : "#FF6C4F", 64 : "#F63D13", 128 : "#F1E15A", 256 : "#EDD450", 512 : "#EED039", 1024 : "#EECD17", 2048 : "#E9C700" }; for (var y = 0; y<rows.length; y++){ var columns = rows[y].getElementsByClassName("sq"); for(var x = 0; x<columns.length; x++){ cells[x][y] = columns[x]; } } var CellObj = function(x, y, value){ this.x = x; this.y = y; this.value = value; }; var GFuncs = { initialCellObjs: function(){ for(var y = 0; y<rows.length; y++){ for(var x = 0; x<columns.length; x++){ cellObjs[x][y] = new CellObj(x, y, null); } } }, dco: function(){ for(var y = 0; y<rows.length; y++){ for(var x = 0; x<columns.length; x++){ if(cellObjs[x][y].value){ cells[x][y].textContent = String(cellObjs[x][y].value); if(cellObjs[x][y].value<=2048){ cells[x][y].style.backgroundColor = clrSch[cellObjs[x][y].value]; } else{ cells[x][y].style.backgroundColor = "#373A34"; } } else{ cells[x][y].textContent = " "; cells[x][y].style.backgroundColor = clrSch.default; } } } }, individualPull:{ right: function(cell){ var i; var tempVal = cell.value; for(i = cell.x + 1; i<rowLength; i++){ if(!cellObjs[i][cell.y].value){ continue; } else{ break; } } cellObjs[cell.x][cell.y].value = null; cellObjs[i-1][cell.y].value = tempVal; }, left: function(cell){ var i; var tempVal = cell.value; for(i = cell.x - 1; i >= 0; i--){ if(!cellObjs[i][cell.y].value){ continue; } else{ break; } } cellObjs[cell.x][cell.y].value = null; cellObjs[i+1][cell.y].value = tempVal; }, bottom: function(cell){ var i; var tempVal = cell.value; for(i = cell.y + 1; i<rows.length; i++){ if(!cellObjs[cell.x][i].value){ continue; } else{ break; } } cellObjs[cell.x][cell.y].value = null; cellObjs[cell.x][i-1].value = tempVal; }, top: function(cell){ var i; var tempVal = cell.value; for(i = cell.y - 1; i>=0; i--){ if(!cellObjs[cell.x][i].value){ continue; } else{ break; } } cellObjs[cell.x][cell.y].value = null; cellObjs[cell.x][i+1].value = tempVal; } }, groupPull : { right: function(){ for(var x = rowLength - 1; x>= 0; x--){ for(var y = 0; y < columnLength; y++){ GFuncs.individualPull.right(cellObjs[x][y]); } } }, left: function(){ for(var x = 0; x < rowLength; x++){ for(var y = 0; y < columnLength; y++){ GFuncs.individualPull.left(cellObjs[x][y]); } } }, bottom: function(){ for(var y = columnLength - 1; y >= 0; y--){ for(var x = 0; x < rowLength; x++){ GFuncs.individualPull.bottom(cellObjs[x][y]); } } }, top: function(){ for(var y = 0; y < columnLength; y++){ for(var x = 0; x < rowLength; x++){ GFuncs.individualPull.top(cellObjs[x][y]); } } } }, merge:{ column: function(colMain, colMerge){ for(var i = 0; i < columnLength; i++){ if(cellObjs[colMain][i].value!=0&&cellObjs[colMerge][i].value!=0){ if(cellObjs[colMain][i].value==cellObjs[colMerge][i].value){ cellObjs[colMain][i].value*=2; score += cellObjs[colMain][i].value; console.log(score); cellObjs[colMerge][i].value = null; } } } }, row: function(rowMain, rowMerge){ for(var i = 0; i < rowLength; i++){ if(cellObjs[i][rowMain].value!=0&&cellObjs[i][rowMain].value!=0){ if(cellObjs[i][rowMain].value==cellObjs[i][rowMerge].value){ cellObjs[i][rowMain].value*=2; score += cellObjs[i][rowMain].value; console.log(score); cellObjs[i][rowMerge].value = null; } } } } }, randomCell: function(){ var emptyPositions = []; for(var y = 0; y < columnLength; y++){ for(var x = 0; x < rowLength; x++){ if(!cellObjs[x][y].value){ emptyPositions.push(x + y*4); } } } var randomXY = emptyPositions[Math.floor(Math.random() * emptyPositions.length)]; return cellObjs[randomXY%4][Math.floor(randomXY/4)]; }, randomGenerate: function(){ var randomNumber; switch (Math.floor(Math.random() * 8)) { case 0: case 1: case 2: case 3: case 4: case 5: case 6: randomNumber = 2; break; case 7: randomNumber = 4; break; default: randomNumber = 2; break; } GFuncs.randomCell().value = randomNumber; } }; GFuncs.initialCellObjs(); GFuncs.randomGenerate(); GFuncs.randomGenerate(); GFuncs.dco(); document.addEventListener("keydown", function(e){ var keyCode = e.keyCode || e.which, arrow = { left: 37, top: 38, right: 39, bottom: 40 }; switch (keyCode) { case arrow.right: GFuncs.groupPull.right(); GFuncs.merge.column(3, 2); GFuncs.groupPull.right(); GFuncs.merge.column(2, 1); GFuncs.groupPull.right(); GFuncs.merge.column(1, 0); GFuncs.groupPull.right(); break; case arrow.left: GFuncs.groupPull.left(); GFuncs.merge.column(0, 1); GFuncs.groupPull.left(); GFuncs.merge.column(1, 2); GFuncs.groupPull.left(); GFuncs.merge.column(2, 3); GFuncs.groupPull.left(); break; case arrow.bottom: GFuncs.groupPull.bottom(); GFuncs.merge.row(3, 2); GFuncs.groupPull.bottom(); GFuncs.merge.row(2, 1); GFuncs.groupPull.bottom(); GFuncs.merge.row(1, 0); GFuncs.groupPull.bottom(); break; case arrow.top: GFuncs.groupPull.top(); GFuncs.merge.row(0, 1); GFuncs.groupPull.top(); GFuncs.merge.row(1, 2); GFuncs.groupPull.top(); GFuncs.merge.row(2, 3); GFuncs.groupPull.top(); break; default: break; } if(keyCode == arrow.left ||keyCode == arrow.right ||keyCode == arrow.top ||keyCode == arrow.bottom){ GFuncs.randomGenerate(); GFuncs.dco(); } }); </script> </body> </html>'
        )));
    }

     function tokenURI(uint256 tokenId) public override view virtual returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{',
                            '"name":"2048.', tokenId.toString(), '", ',

                            '"description":"Can you beat to 2048?", ',

                            '"image":"', 
                            string(abi.encodePacked('data:image/svg+xml;base64,', generateSVG(ownerOf(tokenId)))), '", '

                            '"animation_url": "',
                            string(abi.encodePacked('data:text/html;base64,', generateHTML())), 
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
