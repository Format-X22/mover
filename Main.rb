require 'active_support/all'
require_relative 'Cfg'
require_relative 'Bitmex'
require_relative 'StateStore'
require_relative 'Control'
require_relative 'Cycle'

STATE = StateStore.new
BITMEX = Bitmex.new

control = Thread.new do
	Control.new
end

cycle = Thread.new do
	Cycle.new
end

control.join
cycle.join