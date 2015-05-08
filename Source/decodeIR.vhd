----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Terragnoli 
-- 
-- Create Date:    21:55:45 05/04/2015 
-- Design Name: 	decoding an IR signal
-- Module Name:    decodeIR - Behavioral 
-- Project Name: 	Connect Four
-- Target Devices: ATLYS
-- Tool versions: Spartan 6
-- Description: 	converts an incoming 32 bit IR signal into a button press.  
--
-- Dependencies: big_counter. 
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


entity decodeIR is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           IRsignal : in  STD_LOGIC;
           ButtonHit : out  STD_LOGIC_VECTOR (3 downto 0);
			  somethingDecoded: out std_logic;
			  testingSignals: out std_logic_vector(7 downto 0));
end decodeIR;


architecture Behavioral of decodeIR is


	constant ZeroUpper : unsigned (18 downto 0) := "0001110101001100000";
	constant ZeroLower : unsigned (18 downto 0) := "0001100001101010000";
	
	
	constant OneUpper : unsigned (18 downto 0) := "0101011111100100000";
	constant OneLower : unsigned (18 downto 0) := "0100111000100000000";
	constant startBitUpper : unsigned (18 downto 0) := "1110101001100000000";
	constant startBitLower : unsigned (18 downto 0) := "1101011011011000000";

	
	--TESTBENCH
--	constant OneUpper : unsigned (18 downto 0) := "0000000000000111111";
--	constant OneLower : unsigned (18 downto 0) := "0000000000000000101";
----	constant startBitUpper : unsigned (18 downto 0) := "0000000000000111100";
--	constant startBitLower : unsigned (18 downto 0) := "0000000000000101000";
	
	
	
	
	
	type stateType is (IndefHigh, StartLow, Reset_startCounter, Start_BitCount, 
				Stop_StartBitCount, ClassifyStart, DecideStart, 
				low, Reset_counter, Count_up, End_bitCounter, ClassifyBit, Store, 
				Increment32, check32, waitHigh); 
	signal state : stateType; 
	
	
	
	
	--internal sw's
	signal rollover : std_logic; 
	signal startBit : std_logic; 
	signal shiftRegFull : std_logic; 
	signal shiftRegAddress : unsigned (18 downto 0);
	signal timeCount : unsigned (18 downto 0); 
	
	
	--decoded signals 
	signal decodedSignal : std_logic_vector (31 downto 0); 
	signal decodedBit : std_logic_vector (1 downto 0); 
	signal decodedBitOne : std_logic; 
	signal decodedBitZero : std_logic; 
	
	
	--internal cw
	signal cwInternal : std_logic_vector (6 downto 0); 
	
	signal buttonHitInternal : std_logic_vector(3 downto 0); 
	
	


	signal done : std_logic; 
	
	


begin




--TESTING SIGNALS!!!!
testingSignals(3 downto 0) <=
											"0000" when (state = IndefHigh) else
											"0001" when (state = StartLow) else
											"0010" when (state = Reset_startCounter) else
											"0011" when (state = Start_BitCount) else
											"0100" when (state = Stop_StartBitCount) else
											"0101" when (state = ClassifyStart) else
											"0110" when (state = DecideStart) else
											"0111" when (state = low) else
											"1000" when (state = Reset_counter) else
											"1001" when (state = Count_up) else
											"1010" when (state = End_bitCounter) else
											"1011" when (state = ClassifyBit) else
											"1100" when (state = Store) else
											"1101" when (state = Increment32) else
											"1110" when (state = check32) else
											"1111" when (state = waitHigh) else
											"0000";
											
											
	somethingDecoded <= (buttonHitInternal(0) or buttonHitInternal(1) or 
										buttonHitInternal(2) or buttonHitInternal(3)); 


	testingSignals(4) <= IRsignal; 












--don't want this one with the clock :) 
	process(clk)
	begin
		if(rising_edge(clk)) then 
		
			if(reset = '0')then 
				state <= IndefHigh; 
			else
				case state is
					
					when IndefHigh =>
						if(IRsignal = '0') then 
							state <= StartLow; 
						end if; 
						
					when StartLow =>
						if(IRsignal = '1')then
							state <= Reset_startCounter; 
						end if; 
						
					when Reset_startCounter =>
						state <= Start_BitCount; 
						
					when Start_BitCount =>
						if(IRsignal = '0')then 
							state <= Stop_StartBitCount; 
						end if; 
						
					when Stop_StartBitCount =>
						state <= ClassifyStart; 
						
					when ClassifyStart =>
						state <= DecideStart;
						
					when DecideStart =>
						if(startBit = '0')then 
							state <= StartLow; 
						elsif (startBit = '1') then 
							state <= low; 
						end if; 
						
					when low =>
						if(IRsignal = '1') then 
							state <= Reset_counter; 
						end if; 
						
					when Reset_counter =>
						state <= Count_up; 
						
					when Count_up =>
						if(rollover = '1') then 
							state <= IndefHigh; 
						elsif(IRsignal = '0') then 
							state <= End_bitCounter; 
						end if; 
						
					when End_bitCounter =>
						state <= ClassifyBit; 
						
					when ClassifyBit =>
						state <= Store; 
						
					when Store =>
						state <= Increment32; 
						
					when Increment32 =>
						state <= check32; 
						
					when check32 =>
						if(shiftRegFull = '1') then 
							state <= waitHigh; 
						else
							state <= low; 
						end if; 
					
					when waitHigh =>
						if(IRsignal = '1') then 
							state <= IndefHigh;
						end if; 
					
					
				end case; 							
			end if; 
		end if; 	
	end process;
	




-------------------------------------------------------------------------------------------------------------
	--cwInternal logic
	--	cw(1,0) : timing counter
	--			00 : reset count
	--			01 : unused
	--			10 : hold count value
	--			11 : count 
	--	cw(3,2) : shift register counter
	--			same decoding as for the timing counter
	--	cw(4)	: store the decoded bit in the shift register 
	--			0 : hold register
	--			1 : store a bit
	--	cw(5) : clear shift register
	--			0 : keep as is
	--			1 : clear shift register
	--	cw(6) : enable classify
	--			0 : disabled
	--			1 : enabled 

	cwInternal <= 	
						"0000000" when (state = IndefHigh) else
						"0000000" when (state = StartLow) else
						"0001000" when (state = Reset_startCounter) else
						"0001011" when (state = Start_BitCount) else
						"0001010" when (state = Stop_StartBitCount) else
						"1001010" when (state = ClassifyStart) else
						"0100010" when (state = DecideStart) else
						"0001010" when (state = low) else
						"0001000" when (state = Reset_counter) else
						"0001011" when (state = Count_up) else
						"0001010" when (state = End_bitCounter) else
						"1001010" when (state = ClassifyBit) else
						"0011010" when (state = Store) else
						"0001110" when (state = Increment32) else
						"0001010" when (state = check32) else
						"0001010" when (state = waitHigh) else
						"0000000"; 
---------------------------------------------------------------------------------------------------------------








--LENGTH COUNTER-----------------------------------------------------------------------------------------------
	time_count :  big_counter 
		 Port map( clk => clk, 
						reset => cwInternal(1), 
						ctrl => cwInternal(0), 
						roll => rollover, 
						Q	=> timeCount);	
---------------------------------------------------------------------------------------------------------------









--DECODE BIT---------------------------------------------------------------------------------------------------
	--start bit
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (reset = '0') then
				-- add rese stuff here (Coulston)
				startBit <= '0'; 
			elsf(cwInternal(6) = '1') then 				--now we can decode the signal. 
				if((timeCount >= startBitLower)and (timeCount <= startBitUpper)) then 
					startBit <= '1'; 
				else 
					startBit <= '0'; 
				end if; 
			end if; 
		end if;
	end process; 
	
	--if it's a one
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (Reset = '0') then
			-- add reset stuff here (Dr. Coulston)
				decodedBit <= "00"; 
			elsif (cwInternal(6) = '1') then 				--now we can decode the info bits 
				if((timeCount >= OneLower)and (timeCount <= OneUpper)) then 
					decodedBit <= "11"; 
				elsif((timeCount >= ZeroLower)and (timeCount <= ZeroUpper)) then 
					decodedBit <= "10"; 
				end if; 
			else 
				decodedBit <= "00"; 
			end if; 
		end if;
	end process; 
---------------------------------------------------------------------------------------------------------------


--SHIFT REGISTER COUNTER---------------------------------------------------------------------------------------
	shiftReg_address :  big_counter
		 Port map( clk => clk, 
						reset => cwInternal(3), 
						ctrl => cwInternal(2), 
						roll => open, 
						Q	=> shiftRegAddress);
					
	shiftRegFull <= '1' when (shiftRegAddress > 31) else '0'; 
---------------------------------------------------------------------------------------------------------------











--SHIFT REGISTER-----------------------------------------------------------------------------------------------
	process(clk)
	begin
		if(rising_edge(clk)) then 
			if(cwInternal(5) = '1') then
				decodedSignal <= X"00000000"; 
				
			elsif((cwInternal(4) = '1') and (decodedBit(1) = '1')) then 
				decodedSignal <= decodedSignal(30 downto 0) & decodedBit(0); 
				
			end if; 
		end if;
	end process; 
---------------------------------------------------------------------------------------------------------------
	
	
	
	
	
	
	
	
--DECODED SIGNAL TO BUTTON PRESS-------------------------------------------------------------------------------
	--button decode: 
	--0100  = left
	--0010  = center
	--0001  = right
	--1000  = up
	
	process(clk)
	begin
		if(rising_edge(clk)) then 
			if (Reset = '0') then
				buttonHitInternal <= "0000" ;
			else
				if(decodedSignal ="00000000111111110101000010101111") then 
						buttonHitInternal <= "0100" ;
				elsif (decodedSignal = "00000000111111110000001011111101") then 
					buttonHitInternal <= "0010" ;
				elsif (decodedSignal = "00000000111111110111100010000111") then 
					buttonHitInternal <= "0001" ;
				elsif (decodedSignal = "00000000111111111010000001011111") then 
					buttonHitInternal <= "1000" ;
				elsif (decodedSignal = "11111111111111111111111111111111") then 
					buttonHitInternal <= "1000" ;
				else
					buttonHitInternal <= "0000" ;
				end if; 
			end if; 
		end if; 
	end process; 
	
--	buttonHitInternal <= "0100" when ((decodedSignal = "00000000111111110101000010101111")) else	--LEFT
--								"0010" when ((decodedSignal = "00000000111111110000001011111101")) else	--CENTER
--								"0001" when ((decodedSignal = "00000000111111110111100010000111")) else -- right
--								"1000" when ((decodedSignal = "00000000111111111010000001011111")) else -- top
--								"1000" when ((decodedSignal = "11111111111111111111111111111111")) else --fake button
--								"0000";
	
	ButtonHit <= buttonHitInternal; 
	
---------------------------------------------------------------------------------------------------------------

end Behavioral;