FROM python:3

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy all files into the container
COPY . .

# Install necessary libraries
RUN pip install requests beautifulsoup4 nltk pandas

# Run the script
CMD ["sh", "-c", "python script.py && python script_pandas.py"]
