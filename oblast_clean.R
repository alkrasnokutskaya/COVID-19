library(dplyr)
library(tidyverse)

#Предобработка базы госпитализаций по МО,
#собранной с помощью парсера

# Строки нужно запускать по очереди

# Импорт
oblast <- read.csv(file.choose())

# Сортировка столбца с данными Яндекса ya_street
# Округ
okrug <- str_extract(oblast[,"ya_street"],
                     "(.+округ,|.+округ.+?(?=,))")
okrug <- str_trim(gsub(",","",okrug))
oblast$Округ <- okrug

# Удаляем округа для удобства работы со столбцом
oblast[,"ya_street"] <- str_replace(oblast[,"ya_street"],
                                    "(.+округ,|.+округ.+?(?=,))", "")

# Населённый пункт
np <- str_extract(oblast[,"ya_street"],
                  (".+?(?=,)|.+"))
np <- str_trim(gsub(",","",np))
oblast$Населённый_пункт <- np

# Удаляем нп для удобства работы со столбцом
oblast[,"ya_street"] <- str_replace(oblast[,"ya_street"],
                                    ".+?(?=,)|.+", "")

# Тип населённого пункта
oblast$Тип <- ifelse(grepl("посёлок|территор",
                           oblast$Населённый_пункт),
                     "посёлок",
                     ifelse(grepl("село",
                                  oblast$Населённый_пункт),
                            "село",
                            ifelse(grepl("деревня",
                                         oblast$Населённый_пункт),
                                   "деревня",
                                   ifelse(grepl("(товарищество|дачный|ТИЗ)",
                                                oblast$Населённый_пункт),
                                          "дачный посёлок",
                                          "город"))))

# (Микро)район
distr <- str_extract(oblast[,"ya_street"],
                     "(.+район([^,]+|,))")
distr <- str_trim(gsub(",","",distr))
oblast$Район <- distr

# Удаляем район для удобства работы со столбцом
oblast[,"ya_street"] <- str_replace(oblast[,"ya_street"],
                                    "(.+район([^,]+|,))", "")

# Дом
dom <- str_extract(oblast[,"ya_street"],
                   "([^,]+?)$")
dom <- str_trim(gsub("(.,|,) ","",dom))
oblast$Дом <- dom

# Удаляем дом для удобства работы со столбцом
oblast[,"ya_street"] <- str_replace(oblast[,"ya_street"],
                                    dom, "")
                                                           
# Улица
ul <- str_extract(oblast[,"ya_street"],
                  "([^,]+?,\\s)$")
ul <- str_trim(gsub("(,\\s|,\\s)","",ul))
oblast$Улица <- ul

# Приведение в порядок столбцов
names(oblast)[2] <- "Область"
oblast <- oblast[,c(1, 5, 2, 9, 10, 11, 12, 3, 4, 6, 7)]

# Дополняем округа названиями городов-округов
oblast$Округ <- ifelse(oblast$Населённый_пункт %in% c("Балашиха",
                                                    "Бронницы",
                                                    "Власиха",
                                                    "Восход",
                                                    "Долгопрудный",
                                                    "Домодедово",
                                                    "Дубна",
                                                    "Егорьевск",
                                                    "Жуковский",
                                                    "Зарайск",
                                                    "Звенигород",
                                                    "Звездный городок",
                                                    "Ивантеевка",
                                                    "Истра",
                                                    "Кашира",
                                                    "Клин",
                                                    "Коломна",
                                                    "Королёв",
                                                    "Котельники",
                                                    "Красноармейск",
                                                    "Красногорск",
                                                    "Краснознаменск",
                                                    "Лобня",
                                                    "Лосино-[П|п]етровск",
                                                    "Луховицы",
                                                    "Лыткарино",
                                                    "Люберцы",
                                                    "Наро-[Ф|ф]оминск",
                                                    "Мытищи",
                                                    "Озёры",
                                                    "Орехово-[З|з]уево",
                                                    "Павловский Посад",
                                                    "Подольск",
                                                    "Протвино",
                                                    "Пущино",
                                                    "Реутов",
                                                    "Рошаль",
                                                    "Руза",
                                                    "Серебряные [П|п]руды",
                                                    "Серпухов",
                                                    "Ступино",
                                                    "Фрязино",
                                                    "Химки",
                                                    "Чехов",
                                                    "Черноголовка",
                                                    "Шатура",
                                                    "Шаховская",
                                                    "Электрогорск",
                                                    "Электросталь",
                                                    "Волоколамск",
                                                    "Воскресенск",
                                                    "Дмитров",
                                                    "Лотошино",
                                                    "Можайск",
                                                    "Одинцово",
                                                    "Пушкин",
                                                    "Рамене",
                                                    "Серпухов",
                                                    "Солнечногорск",
                                                    "Талдом",
                                                    "Щёлково"
                                                    ) &
                         is.na(oblast$Округ),
                       oblast$Населённый_пункт,
                       oblast$Округ)

# Сохраняем финальный датасет
write.csv(oblast, "oblast_clean.csv") 





