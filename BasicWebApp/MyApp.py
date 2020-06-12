import yfinance as yf
import streamlit as st

st.write("""
# Simple Stock Price App
Below is the stock **closing price** and **trading volume** of Google!
""")

# https://towardsdatascience.com/how-to-get-stock-data-using-python-c0de1df17e75
# define the ticker symbol for Google's equity
tickerSymbol = 'GOOGL'

# get ticker data
tickerData = yf.Ticker(tickerSymbol)

# get the 10 year historical prices for this ticker
tickerDf = tickerData.history(period='1d', start='2010-5-31', end='2020-5-31')
# Open	High	Low	Close	Volume	Dividends	Stock Splits

st.write("""
## Closing Price
""")
st.line_chart(tickerDf.Close)
st.write("""
## Volume
""")
st.line_chart(tickerDf.Volume)