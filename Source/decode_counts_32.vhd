--------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: C2C John Terragnoli 
--
-- Create Date:   22:18:46 05/04/2015
-- Design Name:   Connect Four
-- Module Name:   C:/Users/C16John.Terragnoli/Documents/Junior year/Academics/Second Semester/ECE 383/ISE Projects/Final_Project_a/decode_counts_32.vhd
-- Project Name:  Final_Project_a
-- Target Device:  ATYLS
-- Tool versions:  Spartan 6
-- Description:   makes sure the IR signal can be decoded properly 
-- 
-- VHDL Test Bench Created by ISE for module: decodeIR
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
 
ENTITY decode_counts_32 IS
END decode_counts_32;
 
ARCHITECTURE behavior OF decode_counts_32 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decodeIR
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         IRsignal : IN  std_logic;
         ButtonHit : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal IRsignal : std_logic := '0';

 	--Outputs
   signal ButtonHit : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decodeIR PORT MAP (
          clk => clk,
          reset => reset,
          IRsignal => IRsignal,
          ButtonHit => ButtonHit
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
		reset <= '1'; 
		
		
		
		IRSignal <=  '1', 
						'0' after 1000 ns, '1' after 1500 ns,
						'0' after 2000 ns,								--beginning
						
						
						--packet of information. 
						'1' after 2100 ns, '0' after 2200 ns, 
						'1' after 2300 ns, '0' after 2400 ns, 
						'1' after 2500 ns, '0' after 2600 ns, 
						'1' after 2700 ns, '0' after 2800 ns, 
						'1' after 2900 ns, '0' after 3000 ns, 
						'1' after 3100 ns, '0' after 3200 ns, 
						'1' after 3300 ns, '0' after 3400 ns, 
						'1' after 3500 ns, '0' after 3600 ns, 
						'1' after 3700 ns, '0' after 3800 ns, 
						'1' after 3900 ns, '0' after 4000 ns, 
						'1' after 4100 ns, '0' after 4200 ns, 
						'1' after 4300 ns, '0' after 4400 ns, 
						'1' after 4500 ns, '0' after 4600 ns, 
						'1' after 4700 ns, '0' after 4800 ns, 
						'1' after 4900 ns, '0' after 5000 ns, 
						'1' after 5100 ns, '0' after 5200 ns, 
						'1' after 5300 ns, '0' after 5400 ns, 
						'1' after 5500 ns, '0' after 5600 ns, 
						'1' after 5700 ns, '0' after 5800 ns, 
						'1' after 5900 ns, '0' after 6000 ns, 
						'1' after 6100 ns, '0' after 6200 ns, 
						'1' after 6300 ns, '0' after 6400 ns, 
						'1' after 6500 ns, '0' after 6600 ns, 
						'1' after 6700 ns, '0' after 6800 ns, 
						'1' after 6900 ns, '0' after 7000 ns, 
						'1' after 7100 ns, '0' after 7200 ns, 
						'1' after 7300 ns, '0' after 7400 ns, 
						'1' after 7500 ns, '0' after 7600 ns, 
						'1' after 7700 ns, '0' after 7800 ns, 
						'1' after 7900 ns, '0' after 8000 ns, 
						'1' after 8100 ns, '0' after 8200 ns, 
						'1' after 8300 ns, '0' after 8400 ns, 
						'1' after 8500 ns; 
						
						

      wait;
   end process;

END;
