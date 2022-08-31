
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SimpleAdd is
		port (
			clk			: in std_logic;
			reset_n		: in std_logic;
			ena_in		: in std_logic;
			regA_out	   : out std_logic_vector(7 downto 0);
			regB_out  	: out std_logic_vector(7 downto 0);
			gpio_in		: in std_logic
		);
end entity;

architecture RTL of SimpleAdd is
	type state_type is ( s0,s1,s2,s3 );
	constant MAXC : natural:= 5209;
	constant MAXH : natural:= 7814;
	signal state : state_type;   

begin

	process (clk,reset_n,ena_in,gpio_in)
		variable count : natural range 0 to MAXH := 0;
		variable index : natural range 0 to 8 := 0;
		variable MAX : natural:= 5209;
	begin
		if reset_n = '0' then
			count := 0;
			index := 0;
			state <= s0;
		elsif rising_edge(clk) then          -- Dés que la clock monte, on regarde dans quel état aller 
			case state is
				when s0 =>
					count := 0;
					if ena_in = '1' then       -- bit de start qu'il censé recevoir 
						if gpio_in = '1' then
							state <= s1;
						end if;
					end if;
				when s1 =>
 
					if gpio_in = '0' then

						regB_out <= std_logic_vector(to_unsigned(0,8));
					   count := 0;
						index := 0;
						MAX := MAXH;
						state <= s2;
					end if;
				when s2 =>
					count := count + 1; 
					if count = MAX then
						MAX := MAXC;
						regA_out(index) <= gpio_in;
						index := index + 1;
						count := 0;
						if index = 8 then 

						regB_out <= std_logic_vector(to_unsigned(1,8));
							state <= s3;
						end if;
					end if;
					
				when s3=>
					count := count + 1; 
					if count = MAX then
						state <= s0;
					end if;	
							
				when others =>
					count := 0;
					state <= s0;
			end case;
		end if;
	end process;
	
end RTL;
