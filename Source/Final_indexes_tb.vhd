--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:55:22 04/20/2015
-- Design Name:   
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Final_Project_a/Final_indexes_tb.vhd
-- Project Name:  Final_Project_a
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Final
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Final_indexes_tb IS
END Final_indexes_tb;
 
ARCHITECTURE behavior OF Final_indexes_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Final
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tmds : OUT  std_logic_vector(3 downto 0);
         tmdsb : OUT  std_logic_vector(3 downto 0);
         IRsignal : IN  std_logic;
         btns : IN  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal IRsignal : std_logic := '0';
   signal btns : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal tmds : std_logic_vector(3 downto 0);
   signal tmdsb : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Final PORT MAP (
          clk => clk,
          reset => reset,
          tmds => tmds,
          tmdsb => tmdsb,
          IRsignal => IRsignal,
          btns => btns
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
		
		reset <= '1'; 
		
		btns <= "00000",
					"10000" after 10 ns, "00001" after 490 ns,			--drop
					"00010" after 500 ns, "00001" after 990 ns, 			--left
					"10000" after 1000 ns, "00001" after 1490 ns, 			--drop
					"01000" after 1500 ns, "00001" after 1990 ns, 			--right
					"10000" after 2000 ns, "00001" after 2490 ns, 			--drop
					"00010" after 2500 ns, "00001" after 2990 ns, 			--left
					"10000" after 3000 ns, "00001" after 3490 ns, 			--drop
					"01000" after 3500 ns, "00001" after 3990 ns, 			--right
					"10000" after 4000 ns, "00001" after 4490 ns, 			--drop
					"00010" after 4500 ns, "00001" after 4990 ns, 			--left
					"10000" after 5000 ns, "00001" after 5490 ns, 			--drop
					"01000" after 5500 ns, "00001" after 5990 ns, 			--right
					"10000" after 6000 ns, "00001" after 6490 ns, 			--drop
					"00010" after 6500 ns, "00001" after 6990 ns, 			--left
					"10000" after 7000 ns, "00001" after 7490 ns,			--drop
					"01000" after 7500 ns, "00001" after 7990 ns, 			--right
					"10000" after 8000 ns, "00001" after 8490 ns, 			--drop
					"00010" after 8500 ns, "00001" after 8990 ns, 			--left
					"10000" after 9500 ns, "00001" after 9990 ns, 			--drop
					"01000" after 10000 ns, "00001" after 10490 ns, 			--right
					"10000" after 10500 ns, "00001" after 10990 ns, 			--drop
					"00010" after 11000 ns, "00001" after 11490 ns, 			--left
					"10000" after 11500 ns, "00001" after 11990 ns, 			--drop
					"01000" after 12000 ns, "00001" after 12490 ns, 			--right
					"10000" after 12500 ns, "00001" after 12990 ns, 			--drop
					"00010" after 13000 ns, "00001" after 13490 ns, 			--left
					"10000" after 13500 ns, "00001" after 13990 ns; 			--drop
					
		
	
		
		
		irsignal <= '0'; 
		

      -- insert stimulus here 

      wait;
   end process;

END;
