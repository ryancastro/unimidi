require "helper"

class UniMIDI::FunctionalTest < UniMIDI::TestCase

  # ** these tests assume that TestOutput is connected to TestInput
  context "UniMIDI" do

    setup do
      sleep(1)
      TestDeviceHelper.setup
    end

    context "full IO" do

      context "using Arrays" do

        setup do
          @messages = VariousMIDIMessages
          @messages_arr = @messages.inject { |a,b| a+b }.flatten
          @received_arr = []
          @pointer = 0
        end

        should "do IO" do
          TestDeviceHelper.devices[:output].open do |output|
            TestDeviceHelper.devices[:input].open do |input|

              input.buffer.clear

              @messages.each do |msg|

                $>.puts "sending: " + msg.inspect

                output.puts(msg)
                sleep(1)
                received = input.gets.map { |m| m[:data] }.flatten

                $>.puts "received: " + received.inspect

                assert_equal(@messages_arr.slice(@pointer, received.length), received)
                @pointer += received.length
                @received_arr += received
              end
              assert_equal(@messages_arr.length, @received_arr.length)
            end
          end

        end
      end

      context "using byte Strings" do

        setup do
          @messages = VariousMIDIByteStrMessages
          @messages_str = @messages.join
          @received_str = ""
          @pointer = 0
        end

        should "do IO" do
          TestDeviceHelper.devices[:output].open do |output|
            TestDeviceHelper.devices[:input].open do |input|

              @messages.each do |msg|

                $>.puts "sending: " + msg.inspect

                output.puts(msg)
                sleep(1)
                received = input.gets_bytestr.map { |m| m[:data] }.flatten.join
                $>.puts "received: " + received.inspect

                assert_equal(@messages_str.slice(@pointer, received.length), received)
                @pointer += received.length
                @received_str += received
              end
              assert_equal(@messages_str, @received_str)

            end
          end


        end

      end

      context "using MIDIMessages" do

        setup do
          @messages = VariousMIDIObjects
          @messages_arr = @messages.map { |m| m.to_bytes }.flatten
          @received_arr = []
          @pointer = 0
        end

        should "do IO" do
          TestDeviceHelper.devices[:output].open do |output|
            TestDeviceHelper.devices[:input].open do |input|

              #input.buffer.clear

              @messages.each do |msg|

                $>.puts "sending: " + msg.inspect

                output.puts(msg)
                sleep(1)
                received = input.gets.map { |m| m[:data] }.flatten

                $>.puts "received: " + received.inspect

                assert_equal(@messages_arr.slice(@pointer, received.length), received)
                @pointer += received.length
                @received_arr += received
              end
              assert_equal(@messages_arr.length, @received_arr.length)

            end
          end
        end

      end

    end

  end

end
