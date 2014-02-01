// PIC 16F609 microprocessor code for Rover.
// Authors: C. Van Dam with PWM code by Chuck Hellebuyck, Beginner's 
//          Guide to Embedded C Programming Volume 2.
// analog input RA0 ADC pin.
// pwm output is RC5
#include <pic.h> // note double underscore below
__CONFIG(INTIO & WDTDIS & MCLRDIS & UNPROTECT); 
// int clock, watchdog off, MCLR off, Code Unprotect
void pause(unsigned short usvalue); //delay function
void msecbase(void); // delay function
main()
{
	PORTC=0x00; // clear portC port
	TRISC=0b00000000; // all portC I/O set to outputs //TRISC=0x00; 
	PORTB =0x00; // clear portB port
	TRISB = 0xFF; // set all to inputs. Only RB4, RB5, RB6, RB7 physical
	ANSEL=0;  //ADC set to digital
	ANSELH = 0; // upper ADC. This is a critical and subtle setting,
	            // not widely documented.
	CM1CON0=0;// comparators off
	CM2CON0=0;
	// ***************PWM *********************
	CCP1CON = 0; // turn CCP module off
	PR2=124; // set PWM period
	CCPR1L=0b00111110; // Duty cycle 50%
	TMR2IE=0; //disable time 2 interrupt
	T2CKPS0 = 1; // set timer2 prescaler to 16
	T2CKPS1 = 1;
	CCP1CON=0b00001100; // configure pwm module, set DB bits to 00
	TMR2ON=1; // turn on timer 2
	while (TMR2IF ==0)
	{
		// wait for start of period
	}
    //	TRISC5= 0; // start PWM signal by making P1A an output
	// ************ A/D setup****************
	TRISA0=1; // make RA0/AN0 an input
	ANSEL= 0b00000001; // configure RA0 and Analog to Digital input
	ADCON0= 0b00000000; // configure A/D to use AN0, left justified
	while(1)
	{
		ADON = 1; // A/D converter on
		GODONE = 1; //start A/D conversion on AN0
		CCPR1L = ADRESH;
		pause(50); // delay in msec
		//Begin States 
		//  <- switch 1	left	switch 2 ^ up
		//	switch 3 down		switch 4 -> right
		// normaly open switches. 
		// Depending on the joystick, may need to adjust input conditions.
		if(RB4==0 && RB5==0 && RB6==1 && RB7==0) // forward
		{
			RC0=0; //UP
			RC1=1;
			RC2=0; //UP
			RC3=1;
		}
		else if(RB4==0 && RB5==1 && RB6==0 && RB7==0) // rev
		{
			RC0=1; //DOWN
			RC1=0;
			RC2=1; //DOWN
			RC3=0;
		}
		else if(RB4==1 && RB5==0 && RB6==0 && RB7==0) // right
		{
			RC0=0; 
			RC1=1;
			RC2=1;
			RC3=0;
		}
		else if(RB4==0 && RB5==0 && RB6==0 && RB7==1) // left
		{
			RC0=1; 
			RC1=0;
			RC2=0;
			RC3=1;
	
		}
		else if(RB4==0 && RB5==0 && RB6==1 && RB7==1) // upperleft
		{
			RC0=1; 
			RC1=1;
			RC2=0;
			RC3=1;
			
		}
		else if(RB4==1 && RB5==0 && RB6==1 && RB7==0) // upper right
		{
			RC0=0;  
			RC1=1;
			RC2=1; 
			RC3=1;
		}
		else if(RB4==0 && RB5==1 && RB6==0 && RB7==1) // low left
		{
			RC0=1; 
			RC1=1;
			RC2=1;
			RC3=0;
		}
		else if(RB4==1 && RB5==1 && RB6==0 && RB7==0) // low right
		{
			RC0=1; 
			RC1=0;
			RC2=1;
			RC3=1;
		}
		else //  RB4==0 && RB5==0 && RB6==0 && RB7=0
		{ // all off
		  RC0=1;
			RC1=1;
			RC2=1;
			RC3=1;	
		}
		//output RC0,RC1,RC2, RC3.  1and2 for M1, 2and3 for M2
	}
}
void pause (unsigned short usvalue)
{
	unsigned short x;
	for (x=0; x<=usvalue; x++)
	{
		msecbase();
	}
}
void msecbase(void)
{
	OPTION = 0b00000001;
	TMR0 = 0xD;
	while(!T0IF);
	T0IF = 0;
}