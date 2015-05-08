----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Paul Terragnoli
-- 
-- Create Date:    13:58:31 01/22/2015 
-- Module Name:    scopeFace - Behavioral 
-- Project Name: lab01
-- Target Devices: ATLYS Spartan 6
-- Tool versions: 1.0
-- Description: responsible for generating the RBG value of a pixel when given 
--					when given the row, column, and pair.  
--
-- Dependencies: VGA
--
-- Revision: none				
-- Revision 0.01 - File Created
-- Additional Comments: none
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;

entity scopeFace is
Port ( row : in  unsigned(11 downto 0);
           column : in  unsigned(11 downto 0);
			  whatOn: in std_logic_vector(3 downto 0); 
			  markerColumn : in unsigned(4 downto 0); 
			  buttonPressed : in std_logic; 
           r : out  std_logic_vector(7 downto 0);
           g : out  std_logic_vector(7 downto 0);
           b : out  std_logic_vector(7 downto 0));
end scopeFace;

architecture Behavioral of scopeFace is

	--CONSTANTS
	constant spaceWidth : unsigned(11 downto 0) := "000000111100"; 
	constant border	: unsigned(11 downto 0) := "000000010100"; 
	
	
	--GRID SIGNALS 
	signal horizontalGrid: std_logic;
	signal verticalGrid: std_logic;
	signal grid: std_logic;
	signal horizontalHash: std_logic;
	signal verticalHash: std_logic;
	signal onOScope: std_logic;
	signal rgb: std_logic_vector(23 downto 0); 
	
	--MARKER SIGNALS
	signal drawMarker: std_logic;
	signal markerBegin : unsigned(11 downto 0);
	signal markerEnd : unsigned(11 downto 0);
	
	
	--REMOTE TESTING SIGNALS
	signal buttonPress : std_logic; 
	
	--WINNING SIGNALS 
	signal BlueWin, RedWin : std_logic; 


	type onType is (empty, PlayerBlue, PlayerRed, marker); 
	signal colorFill: onType; 


begin		

	

	rgb <=		
		x"FFFFFF" when (grid = '1')				 else
		x"00FF00" when (buttonPress = '1')		 else 
		x"0000FF" when (BlueWin = '1') 			 else
		x"FF0000" when (RedWin = '1') 			 else
		x"0000FF" when (colorFill = PlayerBlue) else
		x"FF0000" when (colorFill = PlayerRed)	 else
		x"FFFF33" when (drawMarker = '1') 		 else
		x"000000" when (colorFill = empty) 		 else
		x"000000";








	buttonPress <= '1' when ((buttonPressed = '1') and (row>420))else
						'0'; 





















--Blue win signal-------------------------------------------------------------------------
	BlueWin <= '1' when ((column < 10) and (whatOn = "0100")) else '0'; 
------------------------------------------------------------------------------------------


--RedWin Signal:--------------------------------------------------------------------------
	RedWin <= '1' when ((column > 610) and (whatOn = "0101")) else '0'; 
------------------------------------------------------------------------------------------


--Marker Logic--------------------------------------------------------------------------	
	markerBegin <= 
						(border)			when (markerColumn = "00000") else 
						(border + 60) 	when (markerColumn = "00001") else 
						(border + 120) when (markerColumn = "00010") else 
						(border + 180) when (markerColumn = "00011") else 
						(border + 240) when (markerColumn = "00100") else 
						(border + 300) when (markerColumn = "00101") else 
						(border + 360) when (markerColumn = "00110") else 
						(border + 420) when (markerColumn = "00111") else 
						(border + 480)	when (markerColumn = "01000") else 
						(border + 540) when (markerColumn = "01001") else 
						(border); 

	markerEnd <= markerBegin + spaceWidth; 

	drawMarker <= '1' when ((column >= markerBegin) and 
							(column <= markerEnd) and 
							(row >= 10) and
							(row < 20)) else 
						'0';  
----------------------------------------------------------------------------------------


--parsing rgb values for output--------------------------------------------------------------------
	r <= rgb(23 downto 16); 
	g <= rgb(15 downto 8); 
	b <= rgb(7 downto 0);
----------------------------------------------------------------------------------------------------	
	
--Making input turn easier to read------------------------------------------------------------------
--player 1 is blue
--player 2 is red
	colorFill <= 
					PlayerBlue when (whatOn = "0001") else
					PlayerRed when (whatOn = "0010") else
					marker when (whatOn = "0011") else
					empty when (whatOn = "0000") else
					empty; 
---------------------------------------------------------------------------------------------------
	

	-------------------------------------------------------------------------------------------------------
	--SIMPLIFICATION OF PICTURES---------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------
	horizontalGrid <= '1' when ((column>19) and (column <621) and ((row=20) or (row=70) or (row=120) or (row=170) or 
							(row = 220) or (row = 270) or (row = 320) or (row = 370) or (row=420))) else--horizontal lines
						'0';
						
	verticalGrid <= '1' when ((row>20) and (row<421) and ((column = 20) or (column = 80) or (column =140) or (column = 200) or
							(column = 260) or (column =320) or (column = 380) or (column = 440) or (column = 500) or (column = 560) or
							 (column = 620))) else --verticle lines
						'0';
				
	grid <= '1' when ((horizontalGrid = '1') or (verticalGrid = '1'))
				else '0';

	onOScope <= '1' when((row>19) and (column>19) and (row<421) and (column <621))
				else '0';

	-------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------					

	
end Behavioral;