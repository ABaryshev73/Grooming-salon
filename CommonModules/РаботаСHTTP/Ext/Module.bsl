﻿Функция ПолучитьДанныеИзСервиса(Сервер, АдресЗапроса) Экспорт 
	
    ЗаголовокHTTP = Новый Соответствие;
	
	ЗаголовокHTTP.Вставить("Content-Type", "application/json; charset=UTF-8");
	ЗаголовокHTTP.Вставить("Accept", "application/json");
	
	УспешныйЗапрос = Истина;
	
	HTTPЗапрос = Новый HTTPЗапрос(АдресЗапроса, ЗаголовокHTTP);
	HTTPОтвет = Неопределено;
	ТекстОшибки = "";
	
	Попытка
		Соединение = Новый HTTPСоединение(Сервер,,,,,60);
		HTTPОтвет = Соединение.Получить(HTTPЗапрос);
	Исключение
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		УспешныйЗапрос = Ложь;
	КонецПопытки;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("HTTPМетод", "GET");
	ВозвращаемоеЗначение.Вставить("HTTPЗапрос", HTTPЗапрос);
	ВозвращаемоеЗначение.Вставить("HTTPОтвет", HTTPОтвет);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки", ТекстОшибки);
	ВозвращаемоеЗначение.Вставить("УспешныйЗапрос", УспешныйЗапрос);
	
	Возврат ВозвращаемоеЗначение;

КонецФункции // ПолучитьДанныеИзСервиса() 

































































