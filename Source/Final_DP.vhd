----------------------------------------------------------------------------------
-- Company:  USAFA
-- Engineer: C2C John Terragnoli 
-- 
-- Create Date:    13:29:27 04/17/2015 
-- Design Name: 	Connect Four
-- Module Name:    Final_DP - Behavioral 
-- Project Name:    Connect Four
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description:  Listens to the CU to either save signals, write signals, or end the game, 
--						as directed by the CU
--
-- Dependencies: CU
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

entity Final_DP is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
           sw : out  STD_LOGIC_VECTOR (3 downto 0);
           cw : in  STD_LOGIC_VECTOR (4 downto 0);
           IRsignal : in  STD_LOGIC;
           btns : in  STD_LOGIC_VECTOR (4 downto 0);
			  somethingDecoded : out std_logic;
			  testingSignals: out std_logic_vector(7 downto 0));
end Final_DP;


architecture Behavioral of Final_DP is

	signal row : unsigned (11 downto 0); 
	signal column : unsigned (11 downto 0); 
	signal whatOn : std_logic_vector(3 downto 0); 
	signal whatOn_16 : std_logic_vector(15 downto 0);  
	
	signal colIndex_calc : unsigned (11 downto 0); 
	signal rowIndex_calc: unsigned (11 downto 0); 	
	signal colIndex : unsigned (3 downto 0); 
	signal rowIndex : unsigned (3 downto 0); 
	
	signal onGrid : std_logic;


	--BRAM SIGNALS
	signal chooseRow, chooseCol : unsigned (3 downto 0); 
	signal WrAddr : unsigned (9 downto 0); 
	signal RdAddr : unsigned (9 downto 0); 
	signal whoseTurn : unsigned (1 downto 0); 
	signal finalizedMove : std_logic; 			--this probably isn't necessary, 
	signal not_reset : std_logic;					--as we're reading straight from the ATLYS board.  
	
	
	--Filling BRAM signals.  Need to start at 7 and then subtract.  
	signal fill0, fill1, fill2, fill3, fill4, fill5, fill6, fill7, fill8, fill9 : unsigned (3 downto 0); 
	signal currentFill : unsigned (3 downto 0);
	
	--BUTTON LOGIC SIGNALS
	signal markerColumn : unsigned (3 downto 0); 
	signal old_button, button_activity: std_logic_vector(4 downto 0);
	signal nextTurn : std_logic;
	
	type buttonPress is (enable, left, nothing, right, drop); 
	signal easyButton: buttonPress; 
	
	
	
	--IR SIGNALS 
	signal IRbutton : std_logic_vector(3 downto 0); 
	signal btn : 	std_logic_vector(4 downto 0); 
	signal somethingDecoded_internal : std_logic; 
	
	
	
	--WINNING SIGNALS 
	signal BlueWin, RedWin : std_logic; 
	signal finishedCheckBlue, finishedCheckRed : std_logic; 
	
	
	
	
	
	

begin





--IR DECODING
	DECODE :  decodeIR
		Port map ( clk => clk, 
           reset => reset, 
           IRsignal => IRsignal, 
           ButtonHit => IRButton,
			  somethingDecoded => somethingDecoded_internal,
			  testingSignals => open);
			  
	
	process(clk)
	begin 
		if(rising_edge(clk)) then 
			if(IRButton = "1000") then 
				btn <= "00001"; 
			elsif(IRButton = "0100") then 
				btn <= "00010"; 
			elsif(IRButton = "0010") then 
				btn <= "10000"; 
			elsif(IRButton = "0001") then	
				btn <= "01000"; 
			else
				btn <= "00000"; 
			end if; 
		end if; 
	end process; 
	
	
	testingSignals(3 downto 0) <= btn(4 downto 3) & btn(1 downto 0); 



	somethingDecoded <= somethingDecoded_internal;



--	process(IRButton)
--		begin
--			if(reset = '0') then 
--				testingSignals(0) <= '0';
--				testingSignals(1) <= '0';
--				testingSignals(2) <= '0';
--				testingSignals(3) <= '0';
--				testingSignals(4) <= '0';
--				testingSignals(5) <= '0';
--				testingSignals(6) <= '0';
--				testingSignals(7) <= '0';
--			
--			elsif(IRButton = "0100") then
--				testingSignals(0) <= '1'; 
--			elsif(IRButton = "0010") then
--				testingSignals(1) <= '1';
--			elsif(IRButton = "0001") then
--				testingSignals(2) <= '1';
--			elsif(IRButton = "1000") then
--				testingSignals(3) <= '1';
--			end if; 
--	end process; 




























--WINNING SIGNALS-----------------------------------------------------------
	checkBlueWin : winner 
		Port Map (
			clk => clk, 
			reset => reset, 
			WrAddr => WrAddr, 
			WrEn => cw(0),  
			whoseTurn => std_logic_vector(whoseTurn(1 downto 0)), 
			testTo => "01",
			startCheck => cw(1), 
			finishedCheck => finishedCheckBlue, 
			aWinner=> BlueWin);
			
	checkRedWin : winner 
		Port Map (
			clk => clk, 
			reset => reset, 
			WrAddr => WrAddr, 
			WrEn => cw(0),  
			whoseTurn => std_logic_vector(whoseTurn(1 downto 0)), 
			testTo => "10", 
			startCheck => cw(1), 
			finishedCheck => finishedCheckRed, 
			aWinner => RedWin);
			
	sw(1) <= finishedCheckBlue and finishedCheckRed; 



	--paralyze the program until the game is reset.  
	sw(2) <= BlueWin or RedWin; 
------------------------------------------------------------------------------





--BRAM instant and associated signals----------------------------


	drawingMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 				-- Target BRAM, "9Kb" or "18Kb"
			DEVICE => "SPARTAN6", 				-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
			DO_REG => 0, 							-- Optional output register disabled
			INIT => X"000000000000000000",	-- Initial values on output port
			INIT_FILE => "NONE",					-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 16, 					-- Valid values are 1-36
			READ_WIDTH => 16, 					-- Valid values are 1-36
			SIM_COLLISION_CHECK => "NONE",	-- Simulation collision check
--			SRVAL => X"000000000000000000",	-- Set/Reset value for port output
			SRVAL => X"000000000000000000")	-- Set/Reset value for port output
			
--			INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_02 => X"0000000000000000000000000000000000000000000000010000000000000000",
--			INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_04 => X"0000000000000000000000000000000000000000000000000000000100000001",
--			INIT_05 => X"0000000000000000000000000000000000000000000000000000000100000000",
--			INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000")

--			INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_02 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
--			INIT_04 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_05 => X"0000000000000000000000000000000000000000000000000000000100000000",
--			INIT_06 => X"0000000000000000000000000000000000000000000000010000000100000001",
--			INIT_07 => X"0000000000000000000000000000000000000000000000000000000100000000")


--
--
--			
--			INIT_00 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_01 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_02 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_03 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_04 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_05 => X"0000000000000000000000000002000100020001000200010002000100020001",
--			INIT_06 => X"0000000000000000000000000001000200010002000100020001000200010002",
--			INIT_07 => X"0000000000000000000000000002000100020001000200010002000100020001")
			
			
		port map (
			DO => whatOn_16,					-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => std_logic_vector(RdAddr),		-- Input address, width defined by port depth
			RDCLK => clk,	 				-- 1-bit input clock
			RST => (not_reset),				-- active high reset
			RDEN => '1',					-- read enable 
			REGCE => '1',					-- 1-bit input read output register enable - ignored
			DI => "00000000000000" & std_logic_vector(whoseTurn),	-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11",						-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(WrAddr),		-- Input write address, width defined by write port depth
			WRCLK => clk,		 			-- 1-bit input write clock
			WREN => cw(0));				-- 1-bit input write port enable


	not_reset <= (not reset); 

	WrAddr <= "00" & chooseRow & chooseCol;
	chooseCol <= markerColumn; 
	RdAddr <= "00" & rowIndex & colIndex; 
--	whatOn <= whatOn_18(3 downto 0); 





	--winning logic.  When one player wins, the grid lights up that color.  
	whatOn <= 	"0100" when (BlueWin = '1') else
					"0101" when (RedWin = '1') else
					whatOn_16(3 downto 0); 





--LOOK AT FULL CURRENT COLUMN IS-----------------------------------------------------
currentFill <= fill0 when (markerColumn = "0000") else
					fill1 when (markerColumn = "0001") else 
					fill2 when (markerColumn = "0010") else 
					fill3 when (markerColumn = "0011") else 
					fill4 when (markerColumn = "0100") else 
					fill5 when (markerColumn = "0101") else 
					fill6 when (markerColumn = "0110") else 
					fill7 when (markerColumn = "0111") else 
					fill8 when (markerColumn = "1000") else 
					fill9 when (markerColumn = "1001") else
					"1111"; 
					
chooseRow <= "1010" when reset = '0' else 
				currentFill; 						
-------------------------------------------------------------------------------------



--BUTTON LOGIC---------------------------------------------------------------------------------------------	

--	process(clk)
--		begin
--			if(rising_edge(clk) and (cw(2) = '0')) then
--				if(reset = '0') then
--					old_button <= "00000";
--				else
--					button_activity <= btns and (not old_button);
--				end if;
--				old_button <= btns;
--			end if;
--	end process;

	process(clk)
		begin
			if(rising_edge(clk) and (cw(2) = '0')) then
				if(reset = '0') then
					old_button <= "00000";
				else
					button_activity <= btn and (not old_button);
				end if;
				old_button <= btn;
			end if;
	end process;
	

	process(clk)
		begin 
			if(rising_edge(clk) and (cw(2) = '0')) then
				if(reset = '0') then
					markerColumn <= "0100";     				--start close to the middle column
					fill0 <= "1000"; 								--make sure all of the markers are empty
					fill1 <= "1000"; 								--when the game starts.  
					fill2 <= "1000"; 
					fill3 <= "1000"; 
					fill4 <= "1000"; 
					fill5 <= "1000"; 
					fill6 <= "1000"; 
					fill7 <= "1000"; 
					fill8 <= "1000"; 
					fill9 <= "1000"; 
					
					nextTurn <= '1'; 								--be able to select immediately!! 
					finalizedMove <= '0';						--don't allow anything to be written in the beginning.
					whoseTurn <= "01"; 
					
					
				elsif((button_activity(0) = '1')) then		-- allow next player to place a piece
					nextTurn <= '1'; 
					
					finalizedMove <= '0'; 
					
					
					
					
					
				elsif((button_activity(1) = '1') and (nextTurn = '1'))then		-- move left
					if(markerColumn > 0)then
						markerColumn <= markerColumn - 1;
					end if; 
					
					nextTurn <= '0'; 
					
					
					
					
					
				elsif((button_activity(2) = '1')) then		-- move down
					--nothing
					
					
					
					
					
				elsif((button_activity(3) = '1')and (nextTurn = '1'))then		-- move right
					if(markerColumn < 9) then 
						markerColumn <= markerColumn + 1; 
					end if;
					
					nextTurn <= '0'; 
					
					
					
					
					
				elsif((button_activity(4) = '1') and (nextTurn = '1'))then		--select a column
--				elsif((button_activity(4) = '1'))then		--select a column
				
					nextTurn <= '0'; 								--don't place another piece 
					
					if(currentFill>0)then      				--if there is still room in the current column
					

							finalizedMove <= '1'; 				--allow memory to be updated
							
							
							case markerColumn is					--adding one to that row, there should be room
								when "0000" =>					--	there considering that the program made it
									fill0 <= fill0 - 1;			-- inside this if statement. 
								when "0001" =>
									fill1 <= fill1 - 1;
								when "0010" =>
									fill2 <= fill2 - 1;
								when "0011" =>
									fill3 <= fill3 - 1;
								when "0100" =>
									fill4 <= fill4 - 1;
								when "0101" =>
									fill5 <= fill5 - 1;
								when "0110" =>
									fill6 <= fill6 - 1;
								when "0111" =>
									fill7 <= fill7 - 1;
								when "1000" =>
									fill8 <= fill8 - 1;
								when "1001" =>
									fill9 <= fill9 - 1;
								when others =>
									
							end case; 

--							finalizedMove <= '0';					--stop memory from updating until the next move.  

					--what color to write!  
						if(whoseTurn = "01") then
							whoseTurn <= "10"; 
						elsif(whoseTurn = "10") then
							whoseTurn <= "01"; 
						end if; 

					
					end if; --end fill>0
					
					

					
					
				end if;
			end if;
	end process;
	
	sw(0) <= finalizedMove; 
----------------------------------------------------------------------------------------------------------------	





--for easy button viewing in testbench--------------------------
easyButton <= 
				enable		when (btn = "00001") else 
				left 			when (btn = "00010") else 
				nothing		when (btn = "00100") else 
				right 		when (btn = "01000") else 
				drop		 	when (btn = "10000") else 
				nothing; 
---------------------------------------------------------------


--INDEX DECODING----------------------------------------------------------------
	rowIndex <= rowIndex_calc(3 downto 0); 
	colIndex <= colIndex_calc(3 downto 0); 	
		  
		  
		 
	colIndex_calc <= ((column-20)/60) when (onGrid = '1') else
			"111111111111";
	
	rowIndex_calc <= ((row-20)/50) when (onGrid = '1') else
			"111111111111";  


	onGrid <= '1' when((row>=20) and (column>=20) and (row<=420) and (column<=620))
				else '0';
----------------------------------------------------------------------------------



	video_int :  video 
		 Port map ( clk => clk, 
				  reset =>reset,
				  whatOn => whatOn,
				  markerColumn => '0' & markerColumn, 
				  buttonPressed => somethingDecoded_internal, 
				  tmds => tmds, 
				  tmdsb => tmdsb, 
				  row => row, 
				  column => column,
				  v_synch_out => open);


end Behavioral;

