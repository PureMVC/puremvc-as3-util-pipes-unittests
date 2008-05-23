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
	public class PipeTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function PipeTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new PipeTest( "testConstructor" ) );
   			ts.addTest( new PipeTest( "testConnectingAndDisconnectingTwoPipes" ) );
   			ts.addTest( new PipeTest( "testConnectingToAConnectedPipe" ) );
   			return ts;
   		}
  		
  		/**
  		 * Test the constructor.
  		 */
  		public function testConstructor():void 
  		{
   			var pipe:IPipeFitting = new Pipe();
   			
   			// test assertions
   			assertTrue( "Expecting pipe is Pipe", pipe is Pipe );
   		}

  		/**
  		 * Test connecting and disconnecting two pipes. 
  		 */
  		public function testConnectingAndDisconnectingTwoPipes():void 
  		{
  			// create two pipes
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			// connect them
   			var success:Boolean = pipe1.connect(pipe2);
   			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting connected pipe1 to pipe2", success );
   			
   			// disconnect pipe 2 from pipe 1
   			var disconnectedPipe:IPipeFitting = pipe1.disconnect();
   			assertTrue( "Expecting disconnected pipe2 from  to pipe1", disconnectedPipe === pipe2 );
			
   		}
   		
  		/**
  		 * Test attempting to connect a pipe to a pipe with an output already connected. 
  		 */
  		public function testConnectingToAConnectedPipe():void 
  		{
  			// create two pipes
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();
   			var pipe3:IPipeFitting = new Pipe();

   			// connect them
   			var success:Boolean = pipe1.connect(pipe2);
   			
   			// test assertions
   			assertTrue( "Expecting connected pipe1 to pipe2", success );
   			assertTrue( "Expecting can't connect pipe3 to pipe1", pipe1.connect(pipe3) == false);
   			
			
   		}
   		
	}
}