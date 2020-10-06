@isTest
public with sharing class CalculatorTest {
    @isTest
	static void testSum(){
        Calculator calculator = new Calculator();
        Test.startTest();	
        integer sum = calculator.sum(1,1);
        Test.stopTest();	
        system.assertEquals(2,sum, 'The result should be 2');

    }
}
