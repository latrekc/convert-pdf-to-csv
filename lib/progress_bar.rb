# from http://www.software-testing.com.au/blog/2010/01/13/text-based-progress-bar-in-ruby-for-command-line-programs/
class Progress_bar
        attr_accessor :items_to_do, :items_done

        def initialize(items_to_do, items_done=0)
                reset(items_to_do, items_done)
        end

        def percent_complete
                return (@items_complete * 1.0 / @items_to_do * 1.0) * 100
        end

        def advance(steps_to_advance=1)
                @items_complete += steps_to_advance
        end

        def reset(items_to_do, items_done=0)
                @items_to_do    = items_to_do
                @items_complete = items_done
        end

        def report
                $stderr.print "\r#{progress_bar} #{@items_complete} of #{@items_to_do} done"
        end

        def clear
                $stderr.print "\r" + " " * 100  + "\n"
        end

        def progress_bar
                complete_bar   = (percent_complete / 2.0).floor
                incomplete_bar = ((100 - percent_complete) / 2.0).ceil

                return "[#{"*"*complete_bar}#{"-"*incomplete_bar}]"
        end
end

module Enumerable
        def each_with_progress
                progress = Progress_bar.new(self.size)

                self.each do |item |
                        progress.advance

                        yield item

                        progress.report
                end

                progress.clear
        end
end
