#!/usr/bin/env ruby
# encoding: UTF-8
require 'rubygems'
require 'pdf-reader'
require 'awesome_print'
require 'csv'

filename = "pdf/2009.pdf"

reader = PDF::Reader.new(filename)

receiver = PDF::Reader::RegisterReceiver.new


reader.pages.each do |page|
        page.walk(receiver)
end


# нужно объединять в одну строку по совпадающей у соседних элементов позиции Y
# если у соседних элементов совпадает X и отличается Y, то это одна ячейка с переносом строки

result = {}

pagenum = 0;
position = {
        :current => [],
        :prev    => []
}

receiver.callbacks.each do |cb|
        case cb[:name]
                when  :'page='
                        pagenum = cb[:args][0].number
                        position = {
                                :current => [],
                                :prev    => []
                        }

                when :show_text
                        x, y = position[:current]

                        result[pagenum]       ||= {}
                        result[pagenum][y]    ||= {}
                        result[pagenum][y][x] ||= ''

                        cell  = result[pagenum][y][x]

                        if cell.length > 0
                                cell += "\n"
                        end

                        cell += cb[:args][0].encode('UTF-8', 'CP1251')

                        result[pagenum][y][x] = cell

                        ap  result[pagenum][y][x]

                when :move_text_position
                        position[:prev]    = position[:current]
                        position[:current] = cb[:args]

                        if (position[:current][0] == position[:prev][0])
                                position[:current] = position[:prev]
                        end

                else
                        # ap cb[:name]
        end
end

CSV.open(filename.gsub(/\.pdf$/, ".csv"), "wb") do |csv|
        result.each do |page, table|
                table.each do |y, row|
                        csvRow = []

                        if row.size == 15 # нужно убрать зашитое значение
                                row.each do |x, cell|
                                        csvRow << cell
                                end

                                csv << csvRow
                        end
                end
        end
end