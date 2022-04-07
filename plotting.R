library(readr)
library(ggplot2)

all=read_csv('TRY.csv')
ki=read_csv('ki.csv')
stanford=read_csv('stanford.csv')
lund=read_csv('lund.csv')

ki
aggregate(ki ~ is_open_code, is_open_data, is_coi_pred, is_fund_pred, is_register_pred, data = , FUN = mean, na.rm = TRUE)

aggregate(ki*100, by=list(ki$Publication_Year), FUN=mean)

plot(aggregate(ki$is_open_code*100, by=list(ki$Publication_Year), FUN=mean),type='l', col='red',lwd=3,ylim = c(0, 40),xlab='Years','Transparency indicators (%)')
lines(aggregate(ki$is_open_data*100, by=list(ki$Publication_Year), FUN=mean),type='l', col='blue',lwd=3,ylim = c(0, 40))
lines(aggregate(ki$is_register_pred*100, by=list(ki$Publication_Year), FUN=mean),type='l', col='green',lwd=3,ylim = c(0, 40),)
legend(x='topright', legend=c("open code", "open data",'registered'), col=c("red", "blue",'green'), lty=1:2)
help(legend)

ggplot(ki,aes(x=Publication_Year)) + 
  geom_line(aes(y=is_open_code), color='green') + 
  theme_bw()+
  scale_y_continuous(limits = c(5, 50))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Data sharing over time for the three institutions')+
  xlab('Year')+ylab('Data sharing (%)')

plot(aggregate(ki$is_coi_pred*100, by=list(ki$Publication_Year), FUN=mean),type='l', col='red',lwd=3,ylim = c(0, 100),xlab='Years','Transparency indicators (%)')
lines(aggregate(ki$is_fund_pred*100, by=list(ki$Publication_Year), FUN=mean),type='l', col='blue',lwd=3,ylim = c(0, 40))
legend(x='bottomright', legend=c("coi statement", "funding statement"), col=c("red", "blue"), lty=1:2)

# 0.005 
fisher.test(table(ki$is_coi_pred, ki$Publication_Year), simulate.p.value=TRUE,B=1e7) # 0.002
fisher.test(table(ki$is_register_pred, ki$Publication_Year), simulate.p.value=TRUE,B=1e7) # 0.001
fisher.test(table(ki$is_fund_pred, ki$Publication_Year), simulate.p.value=TRUE,B=1e7) # 0.435
fisher.test(table(ki$is_open_code, ki$Publication_Year), simulate.p.value=TRUE,B=1e7) # 0.0002
fisher.test(table(ki$is_open_data, ki$Publication_Year), simulate.p.value=TRUE,B=1e7) # 0.57

ggplot(all, aes(x=Publication_Year, y=is_open_code, fill=Institution)) + 
  geom_line(aes(linetype = Institution, color=Institution)) + 
  geom_point(aes(color = Institution)) + 
  theme_bw()+
  scale_y_continuous(limits = c(5, 50))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Code sharing over time for the three institutions')+
  xlab('Year')+ylab('Code sharing (%)')

ggplot(all, aes(x=Publication_Year, y=is_open_data, fill=Institution)) + 
  geom_line(aes(linetype = Institution, color=Institution)) + 
  geom_point(aes(color = Institution)) + 
  theme_bw()+
  scale_y_continuous(limits = c(5, 50))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Data sharing over time for the three institutions')+
  xlab('Year')+ylab('Data sharing (%)')

ggplot(all, aes(x=Publication_Year, y=is_coi_pred, fill=Institution)) + 
  geom_line(aes(linetype = Institution, color=Institution)) + 
  geom_point(aes(color = Institution)) + 
  theme_bw()+
  scale_y_continuous(limits = c(50, 100))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Conflict of interest disclosures over time for the three institutions')+
  xlab('Year')+ylab('Data sharing (%)')

ggplot(all, aes(x=Publication_Year, y=is_fund_pred, fill=Institution)) + 
  geom_line(aes(linetype = Institution, color=Institution)) + 
  geom_point(aes(color = Institution)) + 
  theme_bw()+
  scale_y_continuous(limits = c(50, 100))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Funding disclosures over time for the three institutions')+
  xlab('Year')+ylab('Data sharing (%)')

ggplot(all, aes(x=Publication_Year, y=is_register_pred, fill=Institution)) + 
  geom_line(aes(linetype = Institution, color=Institution)) + 
  geom_point(aes(color = Institution)) + 
  theme_bw()+
  scale_y_continuous(limits = c(0, 15))+ scale_x_continuous(limits = c(2017, 2022))+
  labs(title='Registrations over time for the three institutions')+
  xlab('Year')+ylab('Data sharing (%)')

