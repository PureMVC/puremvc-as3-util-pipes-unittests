/*
 PureMVC AS3/MultiCore Pipes Utility Unit Tests
 Copyright (c) 2008 Cliff Hall<cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	
 	/**
	 * Test the Pipe class.
	 */
	public class PipeTest extends TestCase {
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function PipeTest( methodName:String ) {
   			super( methodName );
           }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new PipeTest( "testConstructor" ) );
   			ts.addTest( new PipeTest( "testConnectingTwoPipes" ) );
   			return ts;
   		}
  		
  		/**
  		 * Tests the constructor
  		 */
  		public function testConstructor():void {
   			var pipe:IPipeFitting = new Pipe();
   			
   			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   		}


  		/**
  		 * Tests connecting two pipes 
  		 */
  		public function testConnectingTwoPipes():void {
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			var success:Boolean = pipe1.connect(pipe2);
   			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting successfully connected pipe1 to pipe2", success );
   		}
   		
   		
	}
}