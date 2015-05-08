--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:59:58 05/04/2015
-- Design Name:   
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Final_Project_a/winning_read_test.vhd
-- Project Name:  Final_Project_a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: winner
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
library UNIMACRO;
use UNIMACRO.vcomponents.all;
use work.lab2Parts.all;	
 
ENTITY winning_read_test IS
END winning_read_test;
 
ARCHITECTURE behavior OF winning_read_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT winner
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         WrAddr : IN  unsigned(9 downto 0);
         WrEn : IN  std_logic;
         whoseTurn : IN  std_logic_vector(1 downto 0);
         testTo : IN  std_logic_vector(1 downto 0);
         startCheck : IN  std_logic;
         finishedCheck : OUT  std_logic;
         aWinner : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal WrAddr : unsigned(9 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal whoseTurn : std_logic_vector(1 downto 0) := (others => '0');
   signal testTo : std_logic_vector(1 downto 0) := (others => '0');
   signal startCheck : std_logic := '0';

 	--Outputs
   signal finishedCheck : std_logic;
   signal aWinner : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: winner PORT MAP (
          clk => clk,
          reset => reset,
          WrAddr => WrAddr,
          WrEn => WrEn,
          whoseTurn => whoseTurn,
          testTo => testTo,
          startCheck => startCheck,
          finishedCheck => finishedCheck,
          aWinner => aWinner
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		reset <= '1';
		startCheck <= '1'; 
		WrAddr <= "00" & "0100" & "0010";
		testTo <= "01"; 
		whoseTurn <= "10"; 
		WrEn <= '0'; 
			
		
		

      wait;
   end process;

END;
