
ALTER TABLE shipdata ADD COLUMN shipdata_shiphead_number TEXT REFERENCES shiphead(shiphead_number); 
ALTER TABLE shipdata ADD COLUMN shipdata_base_freight_curr_id INTEGER REFERENCES curr_symbol(curr_id) DEFAULT basecurrid();
ALTER TABLE shipdata ADD COLUMN shipdata_total_freight_curr_id INTEGER REFERENCES curr_symbol(curr_id) DEFAULT basecurrid();

