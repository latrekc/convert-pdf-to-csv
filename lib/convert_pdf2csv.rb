# encoding: UTF-8
require_relative 'progress_bar.rb'
require 'pdf-reader'
require 'csv'

class Convert_pdf2csv
        attr_accessor :max_cols, :result, :pagenum, :position

	def initialize()
	        self.max_cols = 0
                self.result = {}

                self.pagenum = 0;
                self.position = {
                        :current => [],
                        :prev    => []
                }
	end

        public
                def parsePDF(filename, encoding='UTF-8')
                        callbacks = reader(filename)

                        puts "parse reader callbacks"

                        callbacks.each_with_progress do |cb|
                                case cb[:name]
                                        when  :'page='
                                                @pagenum = cb[:args][0].number
                                                @position = {
                                                        :current => [],
                                                        :prev    => []
                                                }

                                        when :show_text
                                                x, y = @position[:current]

                                                # я считаю ячейки относящимися к одной логической строке по совпадению Y координаты
                                                # поэтому чтобы не смешивались строки из разных страниц нужен префикс с номером страницы
                                                row_key = @pagenum.to_s + '/' + y.to_s

                                                @result[row_key]    ||= {}
                                                @result[row_key][x] ||= ''

                                                cell  = @result[row_key][x]

                                                if cell.length > 0
                                                        cell += "\n"
                                                end

                                                value = cb[:args][0]

                                                unless encoding == 'UTF-8'
                                                        value.encode!('UTF-8', encoding)
                                                end

                                                cell += value

                                                max_cols = [@max_cols, @result[row_key].size].max

                                                @result[row_key][x] = cell

                                        when :move_text_position
                                                @position[:prev]    = @position[:current]
                                                @position[:current] = cb[:args]

                                                # если X координата предыдущего значения совпадает с X координатой следующего
                                                # то я предполагаю, что это следующая строка многострочной ячейки
                                                if (@position[:current][0] == @position[:prev][0])
                                                        @position[:current] = @position[:prev]
                                                end

                                        else
                                                # ap cb[:name]
                                end
                        end
                end

                # я предполагаю, что в логической таблице все строки имеют одинаковую "ширину"
                # а все остальное это просто "оформительский мусор"
                # не факт, что это всем нужное поведение, поэтому введен этот параметр
                def generateCSV(filename, choose_only_wide_rows=true)
                        CSV.open(filename, "wb") do |csv|
                                puts "write csv file"

                                @result.each_with_progress do |row_key, row|
                                        csvRow = []

                                        if !choose_only_wide_rows || row.size == @max_cols
                                                row.each do |cell_key, cell|
                                                        csvRow << cell
                                                end

                                                csv << csvRow
                                        end
                                end
                        end
                end

        private 
                def reader(filename)
                        reader = PDF::Reader.new(filename)

                        receiver = PDF::Reader::RegisterReceiver.new

                        puts "read pdf pages"
                        reader.pages.each_with_progress do |page|
                                page.walk(receiver)
                        end

                        # нужно объединять в одну строку по совпадающей у соседних элементов позиции Y
                        # если у соседних элементов совпадает X и отличается Y, то это одна ячейка с переносом строки

                        receiver.callbacks
                end
end
