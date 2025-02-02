﻿
&НаКлиенте
Процедура НоменклатураУслугаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда 
		СтрокаТЧ.СтатьяЗатрат = ПолучитьСтатьюЗатратПоНоменклатуре(СтрокаТЧ.Услуга);
		СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуПоставщиков(СтрокаТЧ.Услуга, Объект.Дата, Объект.Поставщик);
		
	КонецЕсли;
	
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСтатьюЗатратПоНоменклатуре(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Номенклатура);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.СтатьяЗатрат;
	
КонецФункции 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		Если НЕ ЗначениеЗаполнено(Объект.АвторДокумента) Тогда 
		Объект.АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры


 &НаКлиенте
Процедура РассчитатьСуммуДокумента()
	
	Объект.СуммаДокумента = Объект.Номенклатура.Итог("Сумма");
	
КонецПроцедуры 

&НаКлиенте
Процедура НоменклатураКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	РаботаСТабличнымиЧастями.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураЦенаПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.Номенклатура.ТекущиеДанные;
	РаботаСТабличнымиЧастями.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
	РассчитатьСуммуДокумента();
	
КонецПроцедуры


