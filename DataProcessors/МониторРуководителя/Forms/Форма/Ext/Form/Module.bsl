﻿
&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеНаСервере()
	
	ЗаполнитьЧисловыеПоказатели();
	ЗаполнитьГистограммы();
	ЗаполнитьКруговыеДиаграммы();
	
КонецПроцедуры // ЗаполнитьДанныеНаСервере()


&НаСервере
Процедура 	ЗаполнитьЧисловыеПоказатели()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачала", ПериодОбработки);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодОбработки));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПродажиОбороты.СуммаОборот КАК СуммаОборот,
	|	ПродажиОбороты.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТ_Продажи
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_Продажи.СуммаОборот) КАК СуммаОборот,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_Продажи.Регистратор) КАК Регистратор
	|ПОМЕСТИТЬ ВТ_КоличествоРегистраторов
	|ИЗ
	|	ВТ_Продажи КАК ВТ_Продажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_Продажи.СуммаОборот) КАК СуммаОборот
	|ИЗ
	|	ВТ_Продажи КАК ВТ_Продажи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_КоличествоРегистраторов.Регистратор = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫРАЗИТЬ(ВТ_КоличествоРегистраторов.СуммаОборот / ВТ_КоличествоРегистраторов.Регистратор КАК ЧИСЛО(10, 2))
	|	КОНЕЦ КАК СреднийЧек
	|ИЗ
	|	ВТ_КоличествоРегистраторов КАК ВТ_КоличествоРегистраторов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыКлиентов.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ ВТ_ЗаписьКлиента
	|ИЗ
	|	РегистрНакопления.ЗаказыКлиентов КАК ЗаказыКлиентов
	|ГДЕ
	|	ЗаказыКлиентов.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ЗаказыКлиентов.Регистратор ССЫЛКА Документ.ЗаписьКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ЗаписьКлиента.Регистратор) КАК КоличествоЗаписейКлиентов
	|ИЗ
	|	ВТ_ЗаписьКлиента КАК ВТ_ЗаписьКлиента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ЗаписьКлиента.Регистратор) КАК Завершенных
	|ИЗ
	|	ВТ_ЗаписьКлиента КАК ВТ_ЗаписьКлиента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	|		ПО ВТ_ЗаписьКлиента.Регистратор = РеализацияТоваровИУслуг.ДокументОснование
	|ГДЕ
	|	РеализацияТоваровИУслуг.Проведен";
	
	ВсегоЗаписей = 0;
	РезультатПакет = Запрос.ВыполнитьПакет();
	
	ВыборкаПродажи = РезультатПакет[2].Выбрать();
	Если ВыборкаПродажи.Следующий() Тогда 
		ВыручкаЧисло = ВыборкаПродажи.СуммаОборот;
	КонецЕсли;
	
	 ВыборкаСреднийЧек = РезультатПакет[3].Выбрать();
	 Если ВыборкаСреднийЧек.Следующий() Тогда 
		 СреднийЧек = ВыборкаСреднийЧек.СреднийЧек;
	 КонецЕсли;
	 
	 ВыборкаЗаписиКлиентов = РезультатПакет[5].Выбрать();
	 Если ВыборкаЗаписиКлиентов.Следующий() Тогда 
		 ВсегоЗаписей = ВыборкаЗаписиКлиентов.КоличествоЗаписейКлиентов;
	 КонецЕсли;
	 
	 ВыборкаЗаписиЗавершенные = РезультатПакет[6].Выбрать();
	 Если ВыборкаЗаписиЗавершенные.Следующий() Тогда 
		 Завершенных = ВыборкаЗаписиЗавершенные.Завершенных;
		 Если ВсегоЗаписей > 0 Тогда 
			 ПроцентЗавершенных = Окр((100*Завершенных/ВсегоЗаписей), 2);
			 ЗавершенныхПроцентСтрока = СтрШаблон("Это %1 процентов от всех записей", ПроцентЗавершенных);
		 Иначе
			 ЗавершенныхПроцентСтрока = "В этом периоде нет записи клиентов!";
		 КонецЕсли;
	 КонецЕсли;
	 

КонецПроцедуры // 	ЗаполнитьЧисловыеПоказатели

&НаСервере
Процедура ЗаполнитьГистограммы()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ПродажиОбороты.Период, ДЕНЬ) КАК Период,
	|	ПродажиОбороты.СуммаОборот КАК СуммаОборот
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|ИТОГИ
	|	СУММА(СуммаОборот)
	|ПО
	|	Период ПЕРИОДАМИ(ДЕНЬ, &ДатаНачала, &ДатаОкончания)";
	
	Запрос.УстановитьПараметр("ДатаНачала", ПериодОбработки);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодОбработки));
	
	ДиаграммаВыручки.Обновление = Ложь;
	ДиаграммаВыручки.Очистить();
	
    Серия = ДиаграммаВыручки.Серии.Добавить("Оборот");
	Серия.Цвет = WebЦвета.ЛососьСветлый;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период", "Все");
	НомерЗаписи =0;
	ТекущийОстаток = 0;
	ОстатокВчера = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Точка = ДиаграммаВыручки.Точки.Добавить(Выборка.Период);
		Точка.Текст = Формат(Выборка.Период, "ДФ=dd.MM.yy");
		Точка.Расшифровка = Выборка.Период;
		Подсказка = "Выручка " + Выборка.СуммаОборот + " на " + Точка.Текст;
		ДиаграммаВыручки.УстановитьЗначение(Точка, Серия, Выборка.СуммаОборот, Точка.Расшифровка, Подсказка);
		
	КонецЦикла;
	
	ДиаграммаВыручки.Обновление = Истина;
		

КонецПроцедуры // ЗаполнитьГистограммы()

&НаСервере
Процедура ЗаполнитьКруговыеДиаграммы()
	
	ЗаполнитьДиаграммуПоРекламнымУслугам();
	ЗаполнитьДиаграммуПоСотрудникам();
	ЗаполнитьДиаграммуПоУслугам();
	ЗаполнитьДиаграммуПоВидуПитомцевКлиентов();
	
КонецПроцедуры // ЗаполнитьКруговыеДиаграммы()

&НаСервере
Процедура ЗаполнитьДиаграммуПоРекламнымУслугам()

     Запрос = Новый Запрос;
	 Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	ЕСТЬNULL(ПродажиОбороты.Клиент.Источник.Представление, ""Не указан"") КАК ИсточникРекламы,
	 |	КОЛИЧЕСТВО(ПродажиОбороты.Клиент.Источник) КАК Количество
	 |ИЗ
	 |	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
	 |
	 |СГРУППИРОВАТЬ ПО
	 |	ЕСТЬNULL(ПродажиОбороты.Клиент.Источник.Представление, ""Не указан"")";
	 
	 Запрос.УстановитьПараметр("ДатаНачала", ПериодОбработки);
	 Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодОбработки));
	 
	 ДиаграммаПоРекламнымИсточникам.Обновление = Ложь;
	 ДиаграммаПоРекламнымИсточникам.Очистить();
	 
	 Точка = ДиаграммаПоРекламнымИсточникам.Точки.Добавить("Количество");
	 Точка.Текст = "Количество";
	 Точка.ПриоритетЦвета = Ложь;
	 
	 Выборка = Запрос.Выполнить().Выбрать();
	 Пока Выборка.Следующий() Цикл 
		 
		 Серия = ДиаграммаПоРекламнымИсточникам.Серии.Добавить(Выборка.ИсточникРекламы);
		 ДиаграммаПоРекламнымИсточникам.УстановитьЗначение(Точка, Серия, Выборка.Количество, Строка(Выборка.Количество));
		 
	 КонецЦикла;
	 
	 ДиаграммаПоРекламнымИсточникам.Обновление = Истина
	 
 КонецПроцедуры // ЗаполнитьДиаграммуПоРекламнымУслугам()
 
 &НаСервере
 Процедура ЗаполнитьДиаграммуПоВидуПитомцевКлиентов()
 
 	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(КонтрагентыПитомцы.Ссылка) КАК Количество,
	|	КонтрагентыПитомцы.ВидПитомца.Ссылка КАК ВидПитомца
	|ИЗ
	|	Справочник.Контрагенты.Питомцы КАК КонтрагентыПитомцы
	|
	|СГРУППИРОВАТЬ ПО
	|	КонтрагентыПитомцы.ВидПитомца.Ссылка";
	
	ДиаграммаПоВидуПитомцевКлиентов.Обновление = Ложь;
	ДиаграммаПоВидуПитомцевКлиентов.Очистить();
	
	Точка = ДиаграммаПоВидуПитомцевКлиентов.Точки.Добавить("Количество");
	Точка.Текст = "Количество";
	Точка.ПриоритетЦвета = Ложь;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() цикл
		Серия =ДиаграммаПоВидуПитомцевКлиентов.УстановитьСерию(Выборка.ВидПитомца);
		ДиаграммаПоВидуПитомцевКлиентов.УстановитьЗначение(Точка, Серия, Выборка.Количество, Строка(Выборка.Количество));
		
	КонецЦикла;
	
	ДиаграммаПоВидуПитомцевКлиентов.Обновление = Истина;
 
 КонецПроцедуры // ДиаграммаПоВидуПитомцевКлиентов()
 
 

&НаСервере
Процедура ЗаполнитьДиаграммуПоСотрудникам()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СУММА(ПродажиОбороты.СуммаОборот) КАК Сумма,
	|	ПродажиОбороты.Сотрудник.Представление КАК Сотрудник
	|ИЗ
	|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, ) КАК ПродажиОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	ПродажиОбороты.Сотрудник.Представление";
	
	Запрос.УстановитьПараметр("ДатаНачала", ПериодОбработки);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодОбработки));
	
	ДиаграммаВыручкиПоСотрудникам.Обновление = Ложь;
	ДиаграммаВыручкиПоСотрудникам.Очистить();
	
	Точка = ДиаграммаВыручкиПоСотрудникам.Точки.Добавить("Сумма");
	Точка.Текст = "Сумма";
	Точка.ПриоритетЦвета = Ложь;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		
		Серия = ДиаграммаВыручкиПоСотрудникам.Серии.Добавить(Выборка.Сотрудник);
		ДиаграммаВыручкиПоСотрудникам.УстановитьЗначение(Точка, Серия, Выборка.Сумма, Строка(Выборка.Сумма));
		
	КонецЦикла;
	
	ДиаграммаВыручкиПоСотрудникам.Обновление = Истина;
	
КонецПроцедуры // ЗаполнитьДиаграммуПоСотрудникам()

&НаСервере
Процедура ЗаполнитьДиаграммуПоУслугам()

Запрос = Новый Запрос;
Запрос.Текст = 
"ВЫБРАТЬ
|	Продажи.Номенклатура КАК Номенклатура,
|	СУММА(Продажи.СуммаОборот) КАК СуммаОборот,
|	Продажи.Период КАК Период
|ПОМЕСТИТЬ ВТ_Услуги
|ИЗ
|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)) КАК Продажи
|ГДЕ
|	Продажи.СуммаОборот <> 0
|
|СГРУППИРОВАТЬ ПО
|	Продажи.Номенклатура,
|	Продажи.Период
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	СУММА(ПродажиОбороты.СуммаОборот) КАК СуммаОборот
|ПОМЕСТИТЬ ВТ_ВсеПродажи
|ИЗ
|	РегистрНакопления.Продажи.Обороты(&ДатаНачала, &ДатаОкончания, Регистратор, Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)) КАК ПродажиОбороты
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВТ_Услуги.Номенклатура КАК Номенклатура,
|	ВТ_Услуги.СуммаОборот КАК СуммаПродажНоменклатуры,
|	ВТ_ВсеПродажи.СуммаОборот КАК ОбщаяСуммаПоУслугам
|ПОМЕСТИТЬ ВТ_Предитог
|ИЗ
|	ВТ_Услуги КАК ВТ_Услуги
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ВсеПродажи КАК ВТ_ВсеПродажи
|		ПО (ИСТИНА)
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ВЫБОР
|		КОГДА 100 * ВТ_Предитог.СуммаПродажНоменклатуры / ВТ_Предитог.ОбщаяСуммаПоУслугам > 10
|			ТОГДА ВТ_Предитог.Номенклатура.Представление
|		ИНАЧЕ ""Прочее""
|	КОНЕЦ КАК Номенклатура,
|	СУММА(ВТ_Предитог.СуммаПродажНоменклатуры) КАК Сумма
|ИЗ
|	ВТ_Предитог КАК ВТ_Предитог
|
|СГРУППИРОВАТЬ ПО
|	ВЫБОР
|		КОГДА 100 * ВТ_Предитог.СуммаПродажНоменклатуры / ВТ_Предитог.ОбщаяСуммаПоУслугам > 10
|			ТОГДА ВТ_Предитог.Номенклатура.Представление
|		ИНАЧЕ ""Прочее""
|	КОНЕЦ";

Запрос.УстановитьПараметр("ДатаНачала", ПериодОбработки);
Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ПериодОбработки));

ДиаграммаВыручкиПоУслугам.Обновление = Ложь;
ДиаграммаВыручкиПоУслугам.Очистить();

Точка = ДиаграммаВыручкиПоУслугам.Точки.Добавить("Сумма");
Точка.Текст = "Сумма";
Точка.ПриоритетЦвета = Ложь;

Выборка = Запрос.Выполнить().Выбрать();
Пока Выборка.Следующий() Цикл 
	
	Серия = ДиаграммаВыручкиПоУслугам.Серии.Добавить(Выборка.Номенклатура);
	ДиаграммаВыручкиПоУслугам.УстановитьЗначение(Точка, Серия, Выборка.Сумма, Строка(Выборка.Сумма));
	
КонецЦикла;

ДиаграммаВыручкиПоУслугам.Обновление = Истина;

КонецПроцедуры // ЗаполнитьДиаграммуПоУслугам()


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодОбработки=НачалоМесяца(ТекущаяДата());
	МесяцСтрокой = Формат(ПериодОбработки, "ДФ='ММММ гггг'");
	ЗаполнитьДанныеНаСервере();
	
	ДатаЗагрузки = ТекущаяДата();
	ПолучитьКурсыВалютПоДаннымЦБНаСервере();
	КоличествоНовостей = 10;
		
    ЗначениеПоискаПриОткрытии();
	
КонецПроцедуры


&НаКлиенте
Процедура МесяцСтрокойНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Подсказка = "Введите период получения данных";
	ЧастьДаты = ЧастиДаты.Дата;
	Оповещение = Новый ОписаниеОповещения("ПослеВводаПериода", ЭтотОбъект);
	ПоказатьВводДаты(Оповещение, ПериодОбработки, Подсказка, ЧастьДаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаПериода(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		ПериодОбработки = НачалоМесяца(Результат);
		МесяцСтрокой = Формат(ПериодОбработки, "ДФ='ММММ гггг'");
	КонецЕсли;
	
	ЗаполнитьДанныеНаСервере();
	
КонецПроцедуры // ПослеВводаПериода()


&НаСервере
Процедура ПолучитьКурсыВалютПоДаннымЦБНаСервере()

	Сервер = "cbr.ru";
	АдресЗапроса = "/scripts/XML_daily.asp?date_req=" + Формат(ДатаЗагрузки, "ДФ=dd/MM/yyyy");
	ВозвращаемоеЗначение = РаботаСHTTP.ПолучитьДанныеИзСервиса(Сервер, АдресЗапроса);
	
	Если ВозвращаемоеЗначение.УспешныйЗапрос = Ложь Тогда 
		Сообщить(ВозвращаемоеЗначение.ТекстОшибки);
		Возврат;
	ИначеЕсли ВозвращаемоеЗначение.HTTPОтвет.КодСостояния <> 200 Тогда 
		Сообщить(СтрШаблон("Код вернул код состояния, отличный от 200: %1", ВозвращаемоеЗначение.HTTPОтвет.КодСостояния));
		Возврат;
	КонецЕсли;
	
	СтрокаXML = ВозвращаемоеЗначение.HTTPОтвет.ПолучитьТелоКакСтроку();
	ПрочитатьИзXMLПоследовательно(СтрокаXML);
	
    
КонецПроцедуры // ПолучитьКурсыВалютПоДаннымЦБНаСервере()



&НаСервере
Процедура ПрочитатьИзXMLПоследовательно(СтрокаXML)

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);

	
	Валюта = Неопределено;
	
	Пока ЧтениеXML.Прочитать() Цикл 
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда 
			НужнаяВалюта = Ложь;
			 Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
            Если  ЧтениеXML.Имя = "ID" И ЧтениеXML.Значение = "R01235" Тогда
                Валюта = "USD";
            ИначеЕсли ЧтениеXML.Имя = "ID" И ЧтениеXML.Значение = "R01239" Тогда
                Валюта = "EURO";
            ИначеЕсли ЧтениеXML.Имя = "ID" И ЧтениеXML.Значение = "R01335" Тогда
                Валюта = "KZT";
            Иначе
                Валюта = Неопределено;
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;

    Если Валюта <> Неопределено
        И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента
        И ЧтениеXML.Имя = "Value" Тогда
        ЧтениеXML.Прочитать();
        Если Валюта = "USD" Тогда
            КурсДоллара = ЧтениеXML.Значение;
        ИначеЕсли Валюта = "EURO" Тогда
            КурсЕвро = ЧтениеXML.Значение;
        ИначеЕсли Валюта = "KZT" Тогда
            КурсТенге = ЧтениеXML.Значение;
        КонецЕсли;
    КонецЕсли;
КонецЦикла;

ЧтениеXML.Закрыть(); 

КонецПроцедуры // ПрочитатьИзXMLПоследовательно()

&НаСервере
Процедура ЗначениеПоискаПриОткрытии()

	ЯзыкПоиска = Элементы.ЯзыкПоиска.СписокВыбора[0].Значение;
	СтрокаПоиска = "Бизнес";	

КонецПроцедуры // ВидимостиНовостей()


&НаКлиенте
Процедура ЗагрузитьНовости(Команда)
	ЗагрузитьНовостиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНовостиНаСервере()

	ТопНовости ="";
	
	Сервер = "newsapi.org";
	АдресЗапроса = "/v2/everything";
	ПараметрыЗапроса = СтрШаблон("apiKey=%1&sortBy=popularity&from=%2&q=%3", СокрЛП(Константы.API_KEY_newsapi.Получить()),
	Формат(ДатаЗагрузки, "ДФ=yyyy-dd-MM"), СокрЛП(СтрокаПоиска));
	
    АдресЗапроса = АдресЗапроса + "?" + ПараметрыЗапроса;
	ВозвращаемоеЗначение = РаботаСHTTP.ПолучитьДанныеИзСервиса(Сервер, АдресЗапроса);
	
	Если ВозвращаемоеЗначение.УспешныйЗапрос = Ложь Тогда 
		Сообщить(ВозвращаемоеЗначение.ТекстОшибки);
		Возврат;
	ИначеЕсли ВозвращаемоеЗначение.HTTPОтвет.КодСостояния <> 200 Тогда 
		Сообщить(СтрШаблон("Код вернул код состояния, отличный от 200: %1", ВозвращаемоеЗначение.HTTPОтвет.КодСостояния));
		Возврат;
	КонецЕсли;
	
	СтрокаJSON = ВозвращаемоеЗначение.HTTPОтвет.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Новости = ПрочитатьJSON(ЧтениеJSON, Ложь);
	ЧтениеJSON.Закрыть();
	
	Итератор = 1;
	
	Если Новости <> Неопределено Тогда 
		Для Каждого Статья Из Новости.articles Цикл 
			ТопНовости = ТопНовости + Строка(Итератор) + ") " + "Источник: " + Статья.url + Символы.ПС + Статья.title + Символы.ПС;
        ТопНовости = ТопНовости + Статья.description + Символы.ПС + Символы.ПС;
        Если Итератор = КоличествоНовостей Тогда
           прервать;
       КонецЕсли;
       Итератор = Итератор + 1;
    КонецЦикла;
Конецесли; 
	
КонецПроцедуры // ЗагрузитьНовостиНаСервере()

&НаКлиенте
Процедура ЯзыкПоискаПриИзменении(Элемент)
	
	Если ЯзыкПоиска = "1" тогда
		СтрокаПоиска = "Бизнес";
	Иначе 
		СтрокаПоиска = "Business";
	КонецЕсли;
КонецПроцедуры




















































































































