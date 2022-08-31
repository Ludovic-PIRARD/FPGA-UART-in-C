#define soc_cv_av

#define DEBUG

#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "soc_cv_av/socal/socal.h"
#include "soc_cv_av/socal/hps.h"
#include "soc_cv_av/socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 ) //64 MB with 32 bit adress space this is 256 MB
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )
//setting for the HPS2FPGA AXI Bridge
#define ALT_AXI_FPGASLVS_OFST (0xC0000000) // axi_master
#define HW_FPGA_AXI_SPAN (0x40000000) // Bridge span 1GB
#define HW_FPGA_AXI_MASK ( HW_FPGA_AXI_SPAN - 1 )

int main() {

   //pointer to the different address spaces

   void *virtual_base;
   void *axi_virtual_base;
   int fd;

   void *h2p_lw_reg1_addr;
   void *h2p_lw_reg2_addr;

   if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
      printf( "ERROR: could not open \"/dev/mem\"...\n" );
      return( 1 );
   }

   //lightweight HPS-to-FPGA bridge
   virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

   if( virtual_base == MAP_FAILED ) {
      printf( "ERROR: mmap() failed...\n" );
      close( fd );
      return( 1 );
   }

   //HPS-to-FPGA bridge
   axi_virtual_base = mmap( NULL, HW_FPGA_AXI_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd,ALT_AXI_FPGASLVS_OFST );

   if( axi_virtual_base == MAP_FAILED ) {
      printf( "ERROR: axi mmap() failed...\n" );
      close( fd );
      return( 1 );
   }
   //Adder test: Two registers are connected to a adder and place the result in the third register
   printf( "\n\n\n-----------Demarrage-------------\n\n" );

   //the address of the two input (reg1 and reg2) registers and the output register (reg3)
   h2p_lw_reg1_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG1_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
   h2p_lw_reg2_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + PIO_REG2_BASE ) & ( unsigned long)( HW_REGS_MASK ) );

   int iter = 1000000000;
   int x = 0;
   for(; x < iter; x++){
      if ((*((uint32_t*)h2p_lw_reg2_addr))==1) {
        printf("Valeur recue regA   :%c\n", *((uint32_t*)h2p_lw_reg1_addr));
        while((*((uint32_t*)h2p_lw_reg2_addr))==1);
       }
   }
   printf("\n\n\n-----------Fin de la lecture-------------\n\n");
   close( fd );

   return( 0 );
}
