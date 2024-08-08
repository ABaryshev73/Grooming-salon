﻿// В задании "по желанию" не смог реализовать только заполнение периодов если у сотрудника были изменения
&НаСервере
Процедура ПериодНачисленияПриИзмененииНаСервере()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник,
	|	КадроваяИсторияСотрудников.ГрафикРаботы КАК ГрафикРаботы,
	|	КадроваяИсторияСотрудников.Оклад КАК ПоказательРасчета,
	|	КадроваяИсторияСотрудников.Работает КАК Работает,
	|	КадроваяИсторияСотрудников.Период КАК ДатаНачала
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
	|ГДЕ
	|	КадроваяИсторияСотрудников.Работает = ИСТИНА";
	
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Объект.ПериодНачисления));

	
	РезультатЗапроса = Запрос.Выполнить();
	ТексСтр = РезультатЗапроса.Выгрузить();
	
	Объект.Начисления.Загрузить(ТексСтр);
	ДатаОкончанияПериода = КонецМесяца(Объект.ПериодНачисления);
	ДатаНачалаПериода = НачалоМесяца(Объект.ПериодНачисления);
	
	Для Каждого СтрокаТЧ из Объект.Начисления цикл
		СтрокаТЧ.ВидРасчета = ПланыВидовРасчета.Начисления.Оклад;
		СтрокаТЧ.ДатаОкончания = ДатаОкончанияПериода;
		СтрокаТЧ.ДатаНачала = Макс(СтрокаТч.ДатаНачала, ДатаНачалаПериода); 
	КонецЦикла;
	Объект.Начисления.Сортировать("Сотрудник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачисленияПриИзменении(Элемент)
	ПериодНачисленияПриИзмененииНаСервере();
КонецПроцедуры





