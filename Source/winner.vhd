----------------------------------------------------------------------------------
-- Company: 		USAFA
-- Engineer: C2C John Terragnoli 
-- 
-- Create Date:    13:34:18 05/03/2015 
-- Module Name:    winner - Behavioral 
-- Project Name: 	final project connect four
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description: 	should check and see if a winning move has been placed on the board. 
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
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.lab2Parts.all;	


entity winner is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           WrAddr : in  unsigned (9 downto 0);
           WrEn : in  STD_LOGIC;
			  whoseTurn : in std_logic_vector (1 downto 0); 
			  testTo: in std_logic_vector (1 downto 0); 
			  startCheck : in std_logic; 
			  finishedCheck : out std_logic; 
           aWinner : out  STD_LOGIC);
end winner;

architecture Behavioral of winner is
	
	signal anchorRow, anchorCol : unsigned (3 downto 0); 
	signal RdAddr : unsigned (9 downto 0); 
	signal ripRow, ripCol : unsigned (3 downto 0); 
	signal whatOn : std_logic_vector(1 downto 0); 
	signal whatOn_16 : std_logic_vector(15 downto 0);  
	
	
	--SURROUNDING BOXES
	
	signal currentSpot : std_logic_vector(1 downto 0); 
	signal up1, up2, up3, down1, down2, down3 : std_logic_vector (1 downto 0); 
	signal left1, left2, left3, right1, right2, right3 : std_logic_vector(1 downto 0); 
	signal upRight1, upRight2, upRight3 : std_logic_vector(1 downto 0); 
	signal upLeft1, upLeft2, upLeft3 : std_logic_vector(1 downto 0); 
	signal downRight1, downRight2, downRight3 : std_logic_vector(1 downto 0); 
	signal downLeft1, downLeft2, downLeft3 : std_logic_vector(1 downto 0); 

	
	
	--WINNING SEQUENCE SIGNALS
	
	signal horizontal1, horizontal2, horizontal3, horizontal4 : std_logic; 
	signal vertical : std_logic; 
	signal positiveDiag1, positiveDiag2, positiveDiag3, positiveDiag4 : std_logic; 
	signal negativeDiag1, negativeDiag2, negativeDiag3, negativeDiag4 : std_logic;

	
	type stateType is (readyToCheck, State_currentSpot, State_down1, State_down2, State_down3,
				State_left1, State_left2, State_left3, State_right1, State_right2, State_right3, 
				State_upRight1, State_upRight2, State_upRight3,
				State_upLeft1, State_upLeft2, State_upLeft3,
				State_downRight1, State_downRight2, State_downRight3,
				State_downLeft1, State_downLeft2, State_downLeft3, stall1, stall2);
				
	signal state : stateType; 
	

	
	
begin






-----RIPPING BRAM-----------------------------------------------------------------------
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '0') then 
				anchorRow <= (WrAddr(7 downto 4)); 
				anchorCol <= (WrAddr(3 downto 0)); 
				state <= readyToCheck;
			else 
			
			
				CASE state is 
					
					when readyToCheck => 
						anchorRow <= (WrAddr(7 downto 4)); 
						anchorCol <= (WrAddr(3 downto 0)); 
						
						finishedCheck <= '0'; 
						
						if(startCheck = '1')  then
							state <= State_currentSpot; 
						end if; 
						
						
						
						
						
						
						
						

					when State_currentSpot =>
						ripRow <= anchorRow; 
						ripCol <= anchorCol; 
						state <= State_right1; 
						
						
						
						
						
						
						
						
						
						
						
						
					when State_right1 =>
						ripRow <= anchorRow; 
						ripCol <= anchorCol + 1; 
						state <= State_right2; 
						
						
						
						
						
						
					when State_right2 =>
						ripRow <= anchorRow; 
						ripCol <= anchorCol + 2; 
						state <= State_right3; 
						
						
						
						
						currentSpot <= whatOn; 
						
						
						
					
					when State_right3 =>
						ripRow <= anchorRow; 
						ripCol <= anchorCol + 3; 
						state <= State_left1; 
						
						
						
						right1 <= whatOn;
						
						
						
						
					
					when State_left1 =>
						ripRow <= anchorRow; 
						ripCol <= (anchorCol - 1); 
						state <= State_left2;
						
						
						
						
						right2 <= whatOn;
						
						
						
						
					
					when State_left2 =>
						ripRow <= anchorRow; 
						ripCol <= (anchorCol - 2); 
						state <= State_left3;
						
						
						
						
						
						right3 <= whatOn;
						
						
						
						
						
					
					when State_left3 =>
						ripRow <= anchorRow; 
						ripCol <= (anchorCol - 3); 
						state <= State_down1;
						
						
						
						
						
						
						left1 <= whatOn; 
						
						
						
						
						
					when State_down1 => 
						ripRow <= anchorRow + 1; 
						ripCol <= anchorCol; 
						state <= State_down2;
						
						
						left2 <= whatOn;
						
						
						
					
					when State_down2 =>
						ripRow <= anchorRow + 2; 
						ripCol <= anchorCol;
						state <= State_down3;
						
						
						
						left3 <= whatOn;
						
						
						
						
					
					when State_down3 =>	
						ripRow <= anchorRow + 3; 
						ripCol <= anchorCol; 
						state <= State_upRight1;
						
						
						
						
						down1 <= whatOn;
						
						
						
						
						

					
					when State_upRight1 =>
						ripRow <= anchorRow - 1; 
						ripCol <= anchorCol + 1; 
						state <= State_upRight2;
						
						
						down2 <= whatOn;
						
						
						
					
					when State_upRight2 =>
						ripRow <= anchorRow - 2; 
						ripCol <= anchorCol + 2; 
						state <= State_upRight3;
						
						
						
						down3 <= whatOn;
						
						
						
						
					
					when State_upRight3 =>
						ripRow <= anchorRow - 3; 
						ripCol <= anchorCol + 3; 
						state <= State_upLeft1;
						
						
						upRight1 <= whatOn;
						
						
						
						
						
					
					when State_upLeft1 =>
						ripRow <= anchorRow - 1; 
						ripCol <= anchorCol - 1; 
						state <= State_upLeft2;
						
						
						
						upRight2 <= whatOn;
						
						
						
						
					
					when State_upLeft2 =>
						ripRow <= anchorRow - 2; 
						ripCol <= anchorCol - 2; 
						state <= State_upLeft3;
						
						
						upRight3 <= whatOn;
						
						
						
						
						
						
					
					when State_upLeft3 =>
						ripRow <= anchorRow - 3; 
						ripCol <= anchorCol - 3; 
						state <= State_downRight1;
						
						
						upLeft1 <= whatOn;
						
						
						
						
						
						
						
					
					when State_downRight1 =>
						ripRow <= anchorRow + 1; 
						ripCol <= anchorCol + 1; 
						state <= State_downRight2;
						
						
						upLeft2 <= whatOn;
						
						
						
						
						
						
					
					when State_downRight2 =>
						ripRow <= anchorRow + 2; 
						ripCol <= anchorCol + 2; 
						state <= State_downRight3;
						
						
						
						
						upLeft3 <= whatOn;
						
						
						
						
					
					when State_downRight3 =>
						ripRow <= anchorRow + 3; 
						ripCol <= anchorCol + 3; 
						state <= State_downLeft1;
						
						
						
						
						downRight1 <= whatOn;
						
						
						
						
						
						
					
					when State_downLeft1 =>
						ripRow <= anchorRow + 1; 
						ripCol <= anchorCol - 1; 
						state <= State_downLeft2;
						
						
						
						downRight2 <= whatOn;
						
						
						
					
					when State_downLeft2 =>
						ripRow <= anchorRow + 2; 
						ripCol <= anchorCol - 2; 
						state <= State_downLeft3;
						
						
						downRight3 <= whatOn;
						
						
						
						
					
					when State_downLeft3 =>
						ripRow <= anchorRow + 3; 
						ripCol <= anchorCol - 3; 
						state <= stall1;
						
						downLeft1 <= whatOn;
						
						
						
						
					when stall1 => 
						
						downLeft2 <= whatOn;
						
						state <= stall2; 
						
						
						
						
						
						
						
						
					when stall2 => 
					
						downLeft3 <= whatOn; 
						
						
						--LET THE CU KNOW!!!!!
						finishedCheck <= '1';
						
						state <= readyToCheck;
						
						
						
						
						
						
						

					end case; 
				end if; 
		end if;
	end process;
	
----------------------------------------------------------------------------------------












--BRAM Logic-----------------------------------------------------------------------------------------------------------------
	checkingMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 				-- Target BRAM, "9Kb" or "18Kb"
			DEVICE => "SPARTAN6", 				-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
			DO_REG => 0, 							-- Optional output register disabled
			INIT => X"000000000000000000",	-- Initial values on output port
			INIT_FILE => "NONE",					-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 16, 					-- Valid values are 1-36
			READ_WIDTH => 16, 					-- Valid values are 1-36
			SIM_COLLISION_CHECK => "NONE",	-- Simulation collision check
			SRVAL => X"000000000000000000")	-- Set/Reset value for port output
--			SRVAL => X"000000000000000000",	-- Set/Reset value for port output
			
--			INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000")
			
--			INIT_00 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_01 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_02 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_03 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_04 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_05 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_06 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_07 => X"0000000000000000000000000002000100020001000200010002000100020001")
--
--			INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_02 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_04 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_05 => X"0000000000000000000000000000000000000000000000000000000100000000",
--			INIT_06 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_07 => X"0000000000000000000000000000000000000000000000000000000100000000")


--			INIT_00 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_01 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_02 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_03 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_04 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_05 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_06 => X"0000000000000000000000000001000100010001000100010001000100010001",
--			INIT_07 => X"0000000000000000000000000001000100010001000100010001000100010001")

			
		port map (
			DO => whatOn_16,					-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => std_logic_vector(RdAddr),		-- Input address, width defined by port depth
			RDCLK => clk,	 				-- 1-bit input clock
			RST => (not reset),				-- active high reset
			RDEN => '1',					-- read enable 
			REGCE => '1',					-- 1-bit input read output register enable - ignored
			DI => "00000000000000"	& std_logic_vector(whoseTurn),	-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11",						-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(WrAddr),		-- Input write address, width defined by write port depth
			WRCLK => clk,		 			-- 1-bit input write clock
			WREN => WrEn);				-- 1-bit input write port enable
			
			
			
			
			RdAddr <= "00" & ripRow & ripCol; 
			whatOn <= whatOn_16(1 downto 0);





--WINNING SEQUENCE LOGIC----------------------------------------------------------------------------------------------------------
	horizontal1 <= '1' when ((left3 = testTo) and (left2 = testTo) and (left1 = testTo) and (currentSpot = testTo)) else '0';
	horizontal2 <= '1' when ((left2 = testTo) and (left1 = testTo) and (currentSpot = testTo) and (right1 = testTo)) else '0';
	horizontal3 <= '1' when ((left1 = testTo) and (currentSpot = testTo) and (right1 = testTo) and (right2 = testTo)) else '0';
	horizontal4 <= '1' when ((currentSpot = testTo) and (right1 = testTo) and (right2 = testTo) and (right3 = testTo)) else '0';
	
	vertical <= '1' when ((currentSpot = testTo) and (down1 = testTo) and (down2 = testTo) and (down3 = testTo)) else '0';
	
	positiveDiag1 <= '1' when ((upRight3 = testTo) and (upRight2 = testTo) and (upRight1 = testTo) and (currentSpot = testTo)) else '0';
	positiveDiag2 <= '1' when ((upRight2 = testTo) and (upRight1 = testTo) and (currentSpot = testTo) and (downLeft1 = testTo)) else '0';
	positiveDiag3 <= '1' when ((upRight1 = testTo) and (currentSpot = testTo) and (downLeft1 = testTo) and (downLeft2 = testTo)) else '0';
	positiveDiag4 <= '1' when ((currentSpot = testTo) and (downLeft1 = testTo) and (downLeft2 = testTo) and (downLeft3 = testTo)) else '0';
	
	negativeDiag1 <= '1' when ((upLeft3 = testTo) and (upLeft2 = testTo) and (upLeft1 = testTo) and (currentSpot = testTo)) else '0';
	negativeDiag2 <= '1' when ((upLeft2 = testTo) and (upLeft1 = testTo) and (currentSpot = testTo) and (downRight1 = testTo)) else '0';
	negativeDiag3 <= '1' when ((upLeft1 = testTo) and (currentSpot = testTo) and (downRight1 = testTo) and (downRight2 = testTo)) else '0';
	negativeDiag4 <= '1' when ((currentSpot = testTo) and (downRight1 = testTo) and (downRight2 = testTo) and (downRight3 = testTo)) else '0';	
---------------------------------------------------------------------------------------------------------------------------------



--OUTPUT LOGIC----------------------------------------------------------------------------------------------------------------------------------
	aWinner <= '1' when ((horizontal1 = '1') or (horizontal2 = '1') or (horizontal3 = '1') or (horizontal4 = '1') or
								(vertical = '1') or
								(positiveDiag1 = '1') or (positiveDiag2 = '1') or (positiveDiag3 = '1') or (positiveDiag4 = '1') or 
								(negativeDiag1 = '1') or (negativeDiag2 = '1') or (negativeDiag3 = '1') or (negativeDiag4 = '1')) else
					'0'; 			
------------------------------------------------------------------------------------------------------------------------------------------------

end Behavioral;

