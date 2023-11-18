type 
    LiteralType* = enum 
        IntValue,
        FloatValue,
        StringValue,
        IdentifierValue,

    LiteralValue* = object 
        case literalType*: LiteralType
        of IntValue: i*: int32
        of FloatValue: f*: float64
        of StringValue: s*: string 
        of IdentifierValue: id*: string