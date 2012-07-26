converter = Convert_pdf2csv.new

converter.parsePDF(input, 'CP1251')
converter.generateCSV(output)

# я считаю ячейки относящимися к одной логической строке по совпадению Y координаты
# поэтому чтобы не смешивались строки из разных страниц нужен префикс с номером страницы
# если X координата предыдущего значения совпадает с X координатой следующего
# то я предполагаю, что это следующая строка многострочной ячейки
# я предполагаю, что в логической таблице все строки имеют одинаковую "ширину"
# а все остальное это просто "оформительский мусор"
# не факт, что это всем нужное поведение, поэтому введен этот параметр
