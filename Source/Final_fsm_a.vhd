----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:33 04/17/2015 
-- Design Name: 
-- Module Name:    Final_fsm_a - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Createdw
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Final_fsm_a is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  btns : in std_logic_vector (4 downto 0);  
           sw : in  STD_LOGIC_VECTOR (3 downto 0);
           cw : out  STD_LOGIC_VECTOR (4 downto 0));
end Final_fsm_a;



architecture Behavioral of Final_fsm_a is


--creates the different types of states
--type stateType is (init, waitChoose, moveRight, moveLeft, checkValid,writeToken,checkEnd, endScreen); 
--signal state: stateType; 

	type stateType is (init, waitChoose, waitWrite,waitCheck, endGame, decode); 
	signal state : stateType; 
	
	signal columnSelected, writeSomething : std_logic; 
	
	signal finishedChecking : std_logic; 
	
	
begin




--SW-------------------------------------------
	--sw(0) = valid or not
	--sw(1) = end of game or not
	--sw(2): 
			--1 game is over
			--0 game's still on!!
-----------------------------------------------
--	cw <= "00000"; 

	columnSelected <= sw(0);
	finishedChecking <= sw(1); 
	
	--NEXT STATE LOGIC
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then 
				state <= init; 
			else
				case state is 
					
					when init => 
						state <= waitChoose;
					
					when decode => 
						

					
					when waitChoose =>
						if(sw(2) = '1') then 
							state <= endGame; 
						elsif(columnSelected = '1') then 
							state <= waitWrite; 
						end if; 
					
					when waitWrite => 
						state <= waitCheck; 
						
					when waitCheck =>
						if(sw(2) = '1') then 
							state <= endGame;
						elsif(finishedChecking = '1') then 
							state <= waitChoose; 
						end if; 
						
					when endGame =>
						
						if(reset = '0') then 
							state <= init; 
						end if; 
								
					end case; 
		
			end if;
		end if;
	end process;	
	
	--cw(0) = write enable.  
	--cw(1) = start the checking process
	--cw(2) = 	freeze the buttons.  
	--cw(3) = wait until signal is decoded.   (MIGHT NOT NEED THIS!!!)   
		
	--output logic
	cw <= 
			"00010" when (state = waitChoose) else
			"00011" when (state = waitWrite) else
			"00000" when (state = waitCheck) else 
			"00100" when (state = endGame) else
			"00000";	
			
			
end Behavioral;

