#Конвертер PDF файлов с табличными данными в CSV#
Я считаю ячейки относящимися к одной логической строке по совпадению Y координаты, 
поэтому чтобы не смешивались строки из разных страниц нужен префикс с номером страницы.
Если X координата предыдущего значения совпадает с X координатой следующего,
то я предполагаю, что это следующая строка многострочной ячейки.

Я предполагаю, что в логической таблице все строки имеют одинаковую "ширину",
а все остальное это просто "оформительский мусор".
Не факт, что это всем нужное поведение, поэтому его можно регулировать параметром.


	converter = Convert_pdf2csv.new

	converter.parsePDF(input, 'CP1251')
	converter.generateCSV(output)

У класса `Convert_pdf2csv` всего два метода — один парсит PDF файл, а второй сохраняет CSV файл.

Для парсинга PDF используется библиотека [pdf-reader](https://github.com/yob/pdf-reader/)


#Convert PDF files with tabular data to CSV#
I suppose that a cells belonging to the same logical line have the same Y coordinates, so that to do not mix strings of different pages we need to prefix the page number.
If the X coordinate of the previous value the same as with the X coordinate of the next, then I guess that's the next line of multiple-cell.

I guess in the logical table, all rows have the same "width", and everything else is just "ornamental trash."
Not the fact that it is all the desired behavior, so you can adjust the parameter.

	converter = Convert_pdf2csv.new

	converter.parsePDF (input, 'CP1251')
	converter.generateCSV (output)

The class `Convert_pdf2csv` have only two methods - one parses the PDF file, while the second remains a CSV file.

As the PDF parsing library is used [pdf-reader](https://github.com/yob/pdf-reader/)
