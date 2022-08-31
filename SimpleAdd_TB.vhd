
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleAdd_TB is
end entity;

architecture TB of SimpleAdd_TB is
	constant PERIOD       : time := 20 ns;
	signal clk            : std_logic := '0';
	signal reset_n        : std_logic := '0';
	signal sena_in		    : std_logic := '0';
	signal sval		    		: std_logic := '0';
	signal sregA_out	    : std_logic_vector(7 downto 0);
	signal sregB_out	    : std_logic_vector(7 downto 0);
	signal sgpio_in	    : std_logic;
	
	component SimpleAdd is
			port (
				clk			: in std_logic;
				reset_n		: in std_logic;
				ena_in		: in std_logic;
				regA_out	   : out std_logic_vector(7 downto 0);
				regB_out	   : out std_logic_vector(7 downto 0);
				gpio_in		: in std_logic
			);
	end component;

begin

	SimpleAdd_I: SimpleAdd 
	port map (
		clk			=> clk,
		reset_n		=> reset_n,
		ena_in		=> sena_in,
		regA_out	   => sregA_out,
		regB_out  	=> sregB_out,
		gpio_in		=> sgpio_in
	);
	
	reset_n_P: process
	begin
		reset_n <= '0';
		wait for (PERIOD*5209) ;
		reset_n <= '1';
		wait;
	end process;
	
	clk_P: process
	begin
		clk <= '0';
		wait for PERIOD/2;
		clk <= '1';
		wait for PERIOD/2;
	end process;

	stimulus: process
		variable sval		    		: std_logic := '0';

	begin
	
		  sena_in <= '1';
		  sgpio_in <= '1';
		  if reset_n = '0'then
				wait until reset_n = '1';
			end if;
		  wait for (PERIOD*5209);
		  sgpio_in <= '0';                  --bit de start
		  wait for (PERIOD*5209);
		  
		  sgpio_in <= sval;                 -- 1 
		  sval := not sval;
		  wait for (PERIOD*5209);
		  
		  sgpio_in <= sval;                  -- 2 
		  wait for (PERIOD*5209);
		  sval := not sval;
		  sgpio_in <= sval;                  -- 3
		  wait for (PERIOD*5209);
		  sval := not sval;
		  sgpio_in <= sval;                  -- 4
		  wait for (PERIOD*5209);
		  sval := not sval;
		  sgpio_in <= sval;                  -- 5
		  wait for (PERIOD*5209);
		  sval := not sval;
		  sgpio_in <= sval;                  -- 6
		  wait for (PERIOD*5209); 
		  sval := not sval;
		  sgpio_in <= sval;                  -- 7
		  wait for (PERIOD*5209);	
		  sval := not sval;
		  sgpio_in <= sval;                 -- 8
		  
		  sval := not sval;
		  sval := not sval;
		  wait for (PERIOD*5209);
		  
		  sgpio_in <= '1';               --bit de stop
		  wait for (PERIOD*5209);
		  wait for (PERIOD*5209);
		  wait for (PERIOD*5209);
		  
	end process;
	
end TB;
