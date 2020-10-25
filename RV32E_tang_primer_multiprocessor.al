<?xml version="1.0" encoding="UTF-8"?>
<Project>
    <Project_Created_Time>2020-10-11 13:12:26</Project_Created_Time>
    <TD_Version>4.6.18154</TD_Version>
    <UCode>00000000</UCode>
    <Name>RV32E_tang_primer_multiprocessor</Name>
    <HardWare>
        <Family>EG4</Family>
        <Device>EG4S20BG256</Device>
    </HardWare>
    <Source_Files>
        <Verilog>
            <File>src/processor/instructions.v</File>
            <File>src/processor/mem_data_ram.v</File>
            <File>src/processor/rv32e_cpu.v</File>
            <File>src/processor/rv32e_soc.v</File>
            <File>src/rom/program_rom.v</File>
            <File>src/app.v</File>
            <File>src/hex_to_7segment.v</File>
            <File>src/four-port-array.v</File>
        </Verilog>
        <ADC_FILE>constraint/io.adc</ADC_FILE>
        <SDC_FILE/>
        <CWC_FILE/>
    </Source_Files>
    <TOP_MODULE>
        <LABEL/>
        <MODULE>app</MODULE>
        <CREATEINDEX>auto</CREATEINDEX>
    </TOP_MODULE>
    <Project_Settings>
        <Step_Last_Change>2020-10-25 13:19:59</Step_Last_Change>
        <Current_Step>60</Current_Step>
        <Step_Status>true</Step_Status>
    </Project_Settings>
</Project>
