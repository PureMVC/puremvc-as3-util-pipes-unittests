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
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.FilterControlMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	
 	/**
	 * Test the Filter class.
	 */
	public class FilterTest extends TestCase 
	{
  		
   		/**
  		 * Constructor.
  		 * 
  		 * @param methodName the name of the test method an instance to run
  		 */
 	    public function FilterTest( methodName:String ) 
 	    {
   			super( methodName );
        }
  	
 		/**
		 * Create the TestSuite.
		 */
 		public static function suite():TestSuite 
 		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest( new FilterTest( "testConnectingAndDisconnectingIOPipes" ) );
   			ts.addTest( new FilterTest( "testFilteringNormalMessage" ) );
   			ts.addTest( new FilterTest( "testBypassAndFilterModeToggle" ) );
   			ts.addTest( new FilterTest( "testSetParamsByControlMessage" ) );
   			ts.addTest( new FilterTest( "testSetFilterByControlMessage" ) );
   			return ts;
   		}
  		
  		
  		/**
  		 * Test connecting input and output pipes to a filter as well as disconnecting the output.
  		 */
  		public function testConnectingAndDisconnectingIOPipes():void 
  		{

  			// create output pipes 1
   			var pipe1:IPipeFitting = new Pipe();
   			var pipe2:IPipeFitting = new Pipe();

  			// create filter
   			var filter:Filter = new Filter( 'TestFilter' );
   			
   			// connect input fitting
   			var connectedInput:Boolean 	= pipe1.connect( filter );
   			
   			// connect output fitting
   			var connectedOutput:Boolean = filter.connect( pipe2 );
   			
   			// test assertions
   			assertTrue( "Expecting pipe1 is Pipe", pipe1 is Pipe );
   			assertTrue( "Expecting pipe2 is Pipe", pipe2 is Pipe );
   			assertTrue( "Expecting filter is Filter", filter is Filter );
   			assertTrue( "Expecting connected input", connectedInput );
   			assertTrue( "Expecting connected output", connectedOutput );
   			
   			// disconnect pipe 2 from filter
   			var disconnectedPipe:IPipeFitting = filter.disconnect();
   			assertTrue( "Expecting disconnected pipe2 from filter", disconnectedPipe === pipe2 );
   		}
  		
  		
  		/**
  		 * Test applying filter to a normal message.
  		 */
  		public function testFilteringNormalMessage():void 
  		{
			// create messages to send to the queue
   			var message:IPipeMessage = new Message( Message.NORMAL, { width:10, height:2 });
  			
  			// create filter, attach an anonymous listener to the filter output to receive the message,
  			// pass in an anonymous function an parameter object
   			var filter:Filter = new Filter( 'scale', 
   											new PipeListener( this ,callBackMethod ),
   											function( message:IPipeMessage, params:Object ):void { message.getHeader().width *= params.factor; message.getHeader().height *= params.factor;  },
   											{ factor:10 }
   										  );

   			// write messages to the filter
   			var written:Boolean = filter.write( message );
   			
   			// test assertions
			assertTrue( "Expecting message is IPipeMessage", message is IPipeMessage );
			assertTrue( "Expecting filter is Filter", filter is Filter );
   			assertTrue( "Expecting wrote message to filter", written );
   			assertTrue( "Expecting received 1 messages", messagesReceived.length == 1 );

   			// test filtered message assertions 
   			var recieved:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved is IPipeMessage", recieved is IPipeMessage );
   			assertTrue( "Expecting recieved === message", recieved === message ); // object equality
   			assertTrue( "Expecting recieved.getHeader().width == 100", recieved.getHeader().width == 100 ); 
   			assertTrue( "Expecting recieved.getHeader().height == 20", recieved.getHeader().height == 20 ); 
   		}
   		
  		/**
  		 * Test setting filter to bypass mode, writing, then setting back to filter mode and writing. 
  		 */
  		public function testBypassAndFilterModeToggle():void 
  		{
			// create messages to send to the queue
   			var message:IPipeMessage = new Message( Message.NORMAL, { width:10, height:2 });
  			
  			// create filter, attach an anonymous listener to the filter output to receive the message,
  			// pass in an anonymous function an parameter object
   			var filter:Filter = new Filter( 'scale', 
   											new PipeListener( this ,callBackMethod ),
   											function( message:IPipeMessage, params:Object ):void { message.getHeader().width *= params.factor; message.getHeader().height *= params.factor;  },
   											{ factor:10 }
   										  );
			
			// create bypass control message	
			var bypassMessage:FilterControlMessage = new FilterControlMessage(FilterControlMessage.BYPASS, 'scale');

   			// write bypass control message to the filter
   			var bypassWritten:Boolean = filter.write( bypassMessage );
   			
   			// write normal message to the filter
   			var written1:Boolean = filter.write( message );
   			
   			// test assertions
			assertTrue( "Expecting message is IPipeMessage", message is IPipeMessage );
			assertTrue( "Expecting filter is Filter", filter is Filter );
   			assertTrue( "Expecting wrote bypass message to filter", bypassWritten );
   			assertTrue( "Expecting wrote normal message to filter", written1 );
   			assertTrue( "Expecting received 1 messages", messagesReceived.length == 1 );

   			// test filtered message assertions (no change to message)
   			var recieved1:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved1 is IPipeMessage", recieved1 is IPipeMessage );
   			assertTrue( "Expecting recieved1 === message", recieved1 === message ); // object equality
   			assertTrue( "Expecting recieved1.getHeader().width == 10", recieved1.getHeader().width == 10 ); 
   			assertTrue( "Expecting recieved1.getHeader().height == 2", recieved1.getHeader().height == 2 ); 

			// create filter control message	
			var filterMessage:FilterControlMessage = new FilterControlMessage(FilterControlMessage.FILTER, 'scale');

   			// write bypass control message to the filter
   			var filterWritten:Boolean = filter.write( filterMessage );
   			
   			// write normal message to the filter again
   			var written2:Boolean = filter.write( message );

			// test assertions   			
   			assertTrue( "Expecting wrote bypass message to filter", bypassWritten );
   			assertTrue( "Expecting wrote normal message to filter", written1 );
   			assertTrue( "Expecting received 1 messages", messagesReceived.length == 1 );

   			// test filtered message assertions (message filtered)
   			var recieved2:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved2 is IPipeMessage", recieved2 is IPipeMessage );
   			assertTrue( "Expecting recieved2 === message", recieved2 === message ); // object equality
   			assertTrue( "Expecting recieved2.getHeader().width == 100", recieved2.getHeader().width == 100 ); 
   			assertTrue( "Expecting recieved2.getHeader().height == 20", recieved2.getHeader().height == 20 );
   		}

  		/**
  		 * Test setting filter parameters by sending control message. 
  		 */
  		public function testSetParamsByControlMessage():void 
  		{
			// create messages to send to the queue
   			var message:IPipeMessage = new Message( Message.NORMAL, { width:10, height:2 });
  			
  			// create filter, attach an anonymous listener to the filter output to receive the message,
  			// pass in an anonymous function an parameter object
   			var filter:Filter = new Filter( 'scale', 
   											new PipeListener( this ,callBackMethod ),
   											function( message:IPipeMessage, params:Object ):void { message.getHeader().width *= params.factor; message.getHeader().height *= params.factor;  },
   											{ factor:10 }
   										  );
			
			// create setParams control message	
			var setParamsMessage:FilterControlMessage = new FilterControlMessage(FilterControlMessage.SET_PARAMS, 'scale', null, {factor:5});

   			// write filter control message to the filter
   			var setParamsWritten:Boolean = filter.write( setParamsMessage );
   			
   			// write normal message to the filter
   			var written:Boolean = filter.write( message );
   			
   			// test assertions
			assertTrue( "Expecting message is IPipeMessage", message is IPipeMessage );
			assertTrue( "Expecting filter is Filter", filter is Filter );
   			assertTrue( "Expecting wrote bypass message to filter", setParamsWritten );
   			assertTrue( "Expecting wrote normal message to filter", written );
   			assertTrue( "Expecting received 1 messages", messagesReceived.length == 1 );

   			// test filtered message assertions (message filtered with overridden parameters)
   			var recieved:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved is IPipeMessage", recieved is IPipeMessage );
   			assertTrue( "Expecting recieved === message", recieved === message ); // object equality
   			assertTrue( "Expecting recieved.getHeader().width == 50", recieved.getHeader().width == 50 ); 
   			assertTrue( "Expecting recieved.getHeader().height == 10", recieved.getHeader().height == 10 ); 

   		}

  		/**
  		 * Test setting filter function by sending control message. 
  		 */
  		public function testSetFilterByControlMessage():void 
  		{
			// create messages to send to the queue
   			var message:IPipeMessage = new Message( Message.NORMAL, { width:10, height:2 });
  			
  			// create filter, attach an anonymous listener to the filter output to receive the message,
  			// pass in an anonymous function an parameter object
   			var filter:Filter = new Filter( 'scale', 
   											new PipeListener( this ,callBackMethod ),
   											function( message:IPipeMessage, params:Object ):void { message.getHeader().width *= params.factor; message.getHeader().height *= params.factor;  },
   											{ factor:10 }
   										  );
			
			// create setParams control message	
			var setFilterMessage:FilterControlMessage = new FilterControlMessage(FilterControlMessage.SET_FILTER, 'scale', function( message:IPipeMessage, params:Object ):void { message.getHeader().width /= params.factor; message.getHeader().height /= params.factor;  } );

   			// write filter control message to the filter
   			var setFilterWritten:Boolean = filter.write( setFilterMessage );
   			
   			// write normal message to the filter
   			var written:Boolean = filter.write( message );
   			
   			// test assertions
			assertTrue( "Expecting message is IPipeMessage", message is IPipeMessage );
			assertTrue( "Expecting filter is Filter", filter is Filter );
   			assertTrue( "Expecting wrote bypass message to filter", setFilterWritten );
   			assertTrue( "Expecting wrote normal message to filter", written );
   			assertTrue( "Expecting received 1 messages", messagesReceived.length == 1 );

   			// test filtered message assertions (message filtered with overridden filter function)
   			var recieved:IPipeMessage = messagesReceived.shift() as IPipeMessage;
   			assertTrue( "Expecting recieved is IPipeMessage", recieved is IPipeMessage );
   			assertTrue( "Expecting recieved === message", recieved === message ); // object equality
   			assertTrue( "Expecting recieved.getHeader().width == 1", recieved.getHeader().width == 1 ); 
   			assertTrue( "Expecting recieved.getHeader().height == .2", recieved.getHeader().height == .2 ); 

   		}

		/**
		 * Array of received messages.
		 * <P>
		 * Used by <code>callBackMedhod</code> as a place to store
		 * the recieved messages.</P>
		 */     		
   		private var messagesReceived:Array = new Array();
   		
   		/**
   		 * Callback given to <code>PipeListener</code> for incoming message.
   		 * <P>
   		 * Used by <code>testReceiveMessageViaPipeListener</code> 
   		 * to get the output of pipe back into this  test to see 
   		 * that a message passes through the pipe.</P>
   		 */
   		private function callBackMethod( message:IPipeMessage ):void
   		{
   			this.messagesReceived.push( message );
   		}
   		
	}
}