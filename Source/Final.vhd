----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Terragnoli 
-- 
-- Create Date:    14:39:49 04/17/2015 
-- Design Name: 	Connect Four Game
-- Module Name:    Final - Behavioral 
-- Project Name:  Final Project
-- Target Devices: Spartan 6
-- Tool versions: 
-- Description: 
--
-- Dependencies: 	none
--
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments: none
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use work.lab2Parts.all;	

entity Final is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
           btns : in  STD_LOGIC_VECTOR (4 downto 0);
			  JB : inout std_logic_vector(7 downto 0); 
			  led : out std_logic_vector(7 downto 0)
			  );
end Final;

architecture Behavioral of Final is

	signal sw : STD_LOGIC_VECTOR (3 downto 0);
	signal cw : STD_LOGIC_VECTOR (4 downto 0);
	
	signal IRsignal : STD_LOGIC;
	signal somethingDecoded : std_logic;
	signal testingSignals : std_logic_vector (7 downto 0);

begin

	datapath: Final_DP 
		 Port map( clk => clk, 
				  reset => reset, 
				  tmds => tmds,
				  tmdsb => tmdsb,
				  sw => sw, 
				  cw => cw, 
				  IRsignal => IRSignal,    
				  btns => btns,
				  somethingDecoded => somethingDecoded,
				  testingSignals => testingSignals);
				  
	JB(1) <= JB(0);

--	JB(7 downto 2) <= "000000"; 
	
	
	IRSignal <= JB(0); 

	led <= "00000000"; 

--	JB <= "00000000"; 


	JB(5 downto 2) <= testingSignals(3 downto 0); 
	
--	JB(6) <= testingSignals(4); 
--	JB(6) <= somethingDecoded; 
--	JB(6) <= clk; 
	
	
	


	fsm: Final_fsm_a
		Port map(clk => clk, 
				reset => reset, 
				btns => btns,
				sw => sw, 
				cw => cw); 

				  
end Behavioral;


