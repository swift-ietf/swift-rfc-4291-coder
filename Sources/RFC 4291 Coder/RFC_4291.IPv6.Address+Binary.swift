public import Binary_Parseable
public import Binary_Serializable
public import Byte
public import RFC_4291

extension RFC_4291.IPv6.Address: @retroactive Binary.Serializable {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ address: borrowing RFC_4291.IPv6.Address,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        let s = address.segments
        for segment in [s.0, s.1, s.2, s.3, s.4, s.5, s.6, s.7] {
            buffer.append(Byte(bitPattern: UInt8(truncatingIfNeeded: segment >> 8)))
            buffer.append(Byte(bitPattern: UInt8(truncatingIfNeeded: segment)))
        }
    }
}

extension RFC_4291.IPv6.Address: @retroactive Binary.Parseable {

    public static func parse<Source: RangeReplaceableCollection>(
        from source: inout Source
    ) throws(Binary.Parse.Failure) -> RFC_4291.IPv6.Address
    where Source.Element == Byte {
        guard source.count >= 16 else {
            throw .insufficient(needed: 16)
        }

        var iterator = source.makeIterator()
        func next16() -> UInt16 {
            let hi = UInt16(iterator.next()!.bitPattern)
            let lo = UInt16(iterator.next()!.bitPattern)
            return (hi << 8) | lo
        }
        let s0 = next16()
        let s1 = next16()
        let s2 = next16()
        let s3 = next16()
        let s4 = next16()
        let s5 = next16()
        let s6 = next16()
        let s7 = next16()
        source.removeFirst(16)

        return RFC_4291.IPv6.Address(s0, s1, s2, s3, s4, s5, s6, s7)
    }
}
