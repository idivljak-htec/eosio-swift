//
//  EosioTransactionAbisTests.swift
//  EosioSwiftAbieosTests
//
//  Created by Todd Bowden on 2/19/19.
// Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

// swiftlint:disable line_length
import Foundation

import XCTest
@testable import EosioSwift
@testable import EosioSwiftAbieosSerializationProvider

class EosioTransactionAbisTests: XCTestCase {

    var abis: EosioTransaction.Abis!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        abis = EosioTransaction.Abis()
        abis.serializationProvider = EosioAbieosSerializationProvider()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        abis = nil
    }

    func testAddB64Abis() {
        do {
            try abis.addAbi(name: EosioName("eosio.token"), base64: tokenAbiB64)
            try abis.addAbi(name: EosioName("eosio.msig"), base64: msigAbiB64)
            try abis.addAbi(name: EosioName("eosio"), base64: eosioAbiB64)
            let hexabis = abis.hexAbis()
            XCTAssertTrue(hexabis[try EosioName("eosio.token")] == tokenAbiHex)
            XCTAssertTrue(hexabis[try EosioName("eosio.msig")] == msigAbiHex)
            XCTAssertTrue(try abis.hashAbi(name: EosioName("eosio")) == "d745bac0c38f95613e0c1c2da58e92de1e8e94d658d64a00293570cc251d1441")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAddHexAbis() {
        do {
            try abis.addAbi(name: EosioName("eosio.token"), hex: tokenAbiHex)
            try abis.addAbi(name: EosioName("eosio.msig"), hex: msigAbiHex)
            let hexAbis = abis.hexAbis()
            try XCTAssertTrue(hexAbis[EosioName("eosio.token")] == tokenAbiHex)
            try XCTAssertTrue(hexAbis[EosioName("eosio.msig")] == msigAbiHex)
            try XCTAssertTrue(abis.hexAbi(name: EosioName("eosio.token")) == tokenAbiHex)
            try XCTAssertTrue(abis.hexAbi(name: EosioName("eosio.msig")) == msigAbiHex)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAddDataAbis() {
        do {
            try abis.addAbi(name: EosioName("eosio.token"), data: Data(hex: tokenAbiHex))
            try abis.addAbi(name: EosioName("eosio.msig"), data: Data(hex: msigAbiHex))
            let hexAbis = abis.hexAbis()
            try XCTAssertTrue(hexAbis[EosioName("eosio.token")] == tokenAbiHex)
            try XCTAssertTrue(hexAbis[EosioName("eosio.msig")] == msigAbiHex)
            try XCTAssertTrue(abis.hexAbi(name: EosioName("eosio.token")) == tokenAbiHex)
            try XCTAssertTrue(abis.hexAbi(name: EosioName("eosio.msig")) == msigAbiHex)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testHashAbis() {
        do {
            try abis.addAbi(name: EosioName("eosio.token"), hex: tokenAbiHex)
            try abis.addAbi(name: EosioName("eosio.msig"), hex: msigAbiHex)
            let hashAbis = abis.hashAbis()
            try XCTAssertTrue(hashAbis[EosioName("eosio.token")] == "f5c26ae3f825a8e3d26f7e82e889fe531a3376d66811953308944e86aa9030a7")
            try XCTAssertTrue(hashAbis[EosioName("eosio.msig")] == "f3cbebc8d6cb0a6f85d44774b9303615d9523c12a5419192446a6000a0cea732")
            try XCTAssertTrue(abis.hashAbi(name: EosioName("eosio.token")) == "f5c26ae3f825a8e3d26f7e82e889fe531a3376d66811953308944e86aa9030a7")
            try XCTAssertTrue(abis.hashAbi(name: EosioName("eosio.msig")) == "f3cbebc8d6cb0a6f85d44774b9303615d9523c12a5419192446a6000a0cea732")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testAddInvalidAbi() {
        do {
            try abis.addAbi(name: EosioName("invalid"), base64: invalidAbiB64)
            XCTFail("Add Abi command succeeded despite being malformed")
        } catch {
            print(error)
        }

    }

    let tokenAbiHex = "0e656f73696f3a3a6162692f312e30010c6163636f756e745f6e616d65046e616d6505087472616e7366657200040466726f6d0c6163636f756e745f6e616d6502746f0c6163636f756e745f6e616d65087175616e74697479056173736574046d656d6f06737472696e67066372656174650002066973737565720c6163636f756e745f6e616d650e6d6178696d756d5f737570706c79056173736574056973737565000302746f0c6163636f756e745f6e616d65087175616e74697479056173736574046d656d6f06737472696e67076163636f756e7400010762616c616e63650561737365740e63757272656e63795f7374617473000306737570706c790561737365740a6d61785f737570706c79056173736574066973737565720c6163636f756e745f6e616d6503000000572d3ccdcd087472616e73666572a2072d2d2d0a7469746c653a20546f6b656e205472616e736665720a73756d6d6172793a205472616e7366657220746f6b656e732066726f6d206f6e65206163636f756e7420746f20616e6f746865722e0a69636f6e3a2068747470733a2f2f746f6b656e2d7472616e736665722e706e6723636535316566396639656563613334333465383535303765306564343965373666666631323635343232626465643032353566333139366561353963386230630a2d2d2d0a0a2323205472616e73666572205465726d73202620436f6e646974696f6e730a0a492c207b7b66726f6d7d7d2c20636572746966792074686520666f6c6c6f77696e6720746f206265207472756520746f207468652062657374206f66206d79206b6e6f776c656467653a0a0a312e204920636572746966792074686174207b7b7175616e746974797d7d206973206e6f74207468652070726f6365656473206f66206672617564756c656e74206f722076696f6c656e7420616374697669746965732e0a322e2049206365727469667920746861742c20746f207468652062657374206f66206d79206b6e6f776c656467652c207b7b746f7d7d206973206e6f7420737570706f7274696e6720696e6974696174696f6e206f662076696f6c656e636520616761696e7374206f74686572732e0a332e2049206861766520646973636c6f73656420616e7920636f6e747261637475616c207465726d73202620636f6e646974696f6e732077697468207265737065637420746f207b7b7175616e746974797d7d20746f207b7b746f7d7d2e0a0a4920756e6465727374616e6420746861742066756e6473207472616e736665727320617265206e6f742072657665727369626c6520616674657220746865207b7b247472616e73616374696f6e2e64656c61795f7365637d7d207365636f6e6473206f72206f746865722064656c617920617320636f6e66696775726564206279207b7b66726f6d7d7d2773207065726d697373696f6e732e0a0a4966207468697320616374696f6e206661696c7320746f20626520697272657665727369626c7920636f6e6669726d656420616674657220726563656976696e6720676f6f6473206f722073657276696365732066726f6d20277b7b746f7d7d272c204920616772656520746f206569746865722072657475726e2074686520676f6f6473206f72207365727669636573206f7220726573656e64207b7b7175616e746974797d7d20696e20612074696d656c79206d616e6e65722e0000000000a531760569737375650000000000a86cd445066372656174650002000000384f4d113203693634010863757272656e6379010675696e743634076163636f756e740000000000904dc603693634010863757272656e6379010675696e7436340e63757272656e63795f737461747300000000"

    let invalidAbiB64 = "ImVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXKiBy0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly90b2tlbi10cmFuc2Zlci5wbmcjY2U1MWVmOWY5ZWVjYTM0MzRlODU1MDdlMGVkNDllNzZmZmYxMjY1NDIyYmRlZDAyNTVmMzE5NmVhNTljOGIwYwotLS0KCiMjIFRyYW5zZmVyIFRlcm1zICYgQ29uZGl0aW9ucwoKSSwge3tmcm9tfX0sIGNlcnRpZnkgdGhlIGZvbGxvd2luZyB0byBiZSB0cnVlIHRvIHRoZSBiZXN0IG9mIG15IGtub3dsZWRnZToKCjEuIEkgY2VydGlmeSB0aGF0IHt7cXVhbnRpdHl9fSBpcyBub3QgdGhlIHByb2NlZWRzIG9mIGZyYXVkdWxlbnQgb3IgdmlvbGVudCBhY3Rpdml0aWVzLgoyLiBJIGNlcnRpZnkgdGhhdCwgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlLCB7e3RvfX0gaXMgbm90IHN1cHBvcnRpbmcgaW5pdGlhdGlvbiBvZiB2aW9sZW5jZSBhZ2FpbnN0IG90aGVycy4KMy4gSSBoYXZlIGRpc2Nsb3NlZCBhbnkgY29udHJhY3R1YWwgdGVybXMgJiBjb25kaXRpb25zIHdpdGggcmVzcGVjdCB0byB7e3F1YW50aXR5fX0gdG8ge3t0b319LgoKSSB1bmRlcnN0YW5kIHRoYXQgZnVuZHMgdHJhbnNmZXJzIGFyZSBub3QgcmV2ZXJzaWJsZSBhZnRlciB0aGUge3skdHJhbnNhY3Rpb24uZGVsYXlfc2VjfX0gc2Vjb25kcyBvciBvdGhlciBkZWxheSBhcyBjb25maWd1cmVkIGJ5IHt7ZnJvbX19J3MgcGVybWlzc2lvbnMuCgpJZiB0aGlzIGFjdGlvbiBmYWlscyB0byBiZSBpcnJldmVyc2libHkgY29uZmlybWVkIGFmdGVyIHJlY2VpdmluZyBnb29kcyBvciBzZXJ2aWNlcyBmcm9tICd7e3RvfX0nLCBJIGFncmVlIHRvIGVpdGhlciByZXR1cm4gdGhlIGdvb2RzIG9yIHNlcnZpY2VzIG9yIHJlc2VuZCB7e3F1YW50aXR5fX0gaW4gYSB0aW1lbHkgbWFubmVyLgAAAAAApTF2BWlzc3VlAAAAAACobNRFBmNyZWF0ZQACAAAAOE9NETIDaTY0AQhjdXJyZW5jeQEGdWludDY0B2FjY291bnQAAAAAAJBNxgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQOY3VycmVuY3lfc3RhdHMAAAAA"

    let tokenAbiB64 = "DmVvc2lvOjphYmkvMS4wAQxhY2NvdW50X25hbWUEbmFtZQUIdHJhbnNmZXIABARmcm9tDGFjY291bnRfbmFtZQJ0bwxhY2NvdW50X25hbWUIcXVhbnRpdHkFYXNzZXQEbWVtbwZzdHJpbmcGY3JlYXRlAAIGaXNzdWVyDGFjY291bnRfbmFtZQ5tYXhpbXVtX3N1cHBseQVhc3NldAVpc3N1ZQADAnRvDGFjY291bnRfbmFtZQhxdWFudGl0eQVhc3NldARtZW1vBnN0cmluZwdhY2NvdW50AAEHYmFsYW5jZQVhc3NldA5jdXJyZW5jeV9zdGF0cwADBnN1cHBseQVhc3NldAptYXhfc3VwcGx5BWFzc2V0Bmlzc3VlcgxhY2NvdW50X25hbWUDAAAAVy08zc0IdHJhbnNmZXKiBy0tLQp0aXRsZTogVG9rZW4gVHJhbnNmZXIKc3VtbWFyeTogVHJhbnNmZXIgdG9rZW5zIGZyb20gb25lIGFjY291bnQgdG8gYW5vdGhlci4KaWNvbjogaHR0cHM6Ly90b2tlbi10cmFuc2Zlci5wbmcjY2U1MWVmOWY5ZWVjYTM0MzRlODU1MDdlMGVkNDllNzZmZmYxMjY1NDIyYmRlZDAyNTVmMzE5NmVhNTljOGIwYwotLS0KCiMjIFRyYW5zZmVyIFRlcm1zICYgQ29uZGl0aW9ucwoKSSwge3tmcm9tfX0sIGNlcnRpZnkgdGhlIGZvbGxvd2luZyB0byBiZSB0cnVlIHRvIHRoZSBiZXN0IG9mIG15IGtub3dsZWRnZToKCjEuIEkgY2VydGlmeSB0aGF0IHt7cXVhbnRpdHl9fSBpcyBub3QgdGhlIHByb2NlZWRzIG9mIGZyYXVkdWxlbnQgb3IgdmlvbGVudCBhY3Rpdml0aWVzLgoyLiBJIGNlcnRpZnkgdGhhdCwgdG8gdGhlIGJlc3Qgb2YgbXkga25vd2xlZGdlLCB7e3RvfX0gaXMgbm90IHN1cHBvcnRpbmcgaW5pdGlhdGlvbiBvZiB2aW9sZW5jZSBhZ2FpbnN0IG90aGVycy4KMy4gSSBoYXZlIGRpc2Nsb3NlZCBhbnkgY29udHJhY3R1YWwgdGVybXMgJiBjb25kaXRpb25zIHdpdGggcmVzcGVjdCB0byB7e3F1YW50aXR5fX0gdG8ge3t0b319LgoKSSB1bmRlcnN0YW5kIHRoYXQgZnVuZHMgdHJhbnNmZXJzIGFyZSBub3QgcmV2ZXJzaWJsZSBhZnRlciB0aGUge3skdHJhbnNhY3Rpb24uZGVsYXlfc2VjfX0gc2Vjb25kcyBvciBvdGhlciBkZWxheSBhcyBjb25maWd1cmVkIGJ5IHt7ZnJvbX19J3MgcGVybWlzc2lvbnMuCgpJZiB0aGlzIGFjdGlvbiBmYWlscyB0byBiZSBpcnJldmVyc2libHkgY29uZmlybWVkIGFmdGVyIHJlY2VpdmluZyBnb29kcyBvciBzZXJ2aWNlcyBmcm9tICd7e3RvfX0nLCBJIGFncmVlIHRvIGVpdGhlciByZXR1cm4gdGhlIGdvb2RzIG9yIHNlcnZpY2VzIG9yIHJlc2VuZCB7e3F1YW50aXR5fX0gaW4gYSB0aW1lbHkgbWFubmVyLgAAAAAApTF2BWlzc3VlAAAAAACobNRFBmNyZWF0ZQACAAAAOE9NETIDaTY0AQhjdXJyZW5jeQEGdWludDY0B2FjY291bnQAAAAAAJBNxgNpNjQBCGN1cnJlbmN5AQZ1aW50NjQOY3VycmVuY3lfc3RhdHMAAAAA"

    let msigAbiB64 = "DmVvc2lvOjphYmkvMS4wAwxhY2NvdW50X25hbWUEbmFtZQ9wZXJtaXNzaW9uX25hbWUEbmFtZQthY3Rpb25fbmFtZQRuYW1lDBBwZXJtaXNzaW9uX2xldmVsAAIFYWN0b3IMYWNjb3VudF9uYW1lCnBlcm1pc3Npb24PcGVybWlzc2lvbl9uYW1lBmFjdGlvbgAEB2FjY291bnQMYWNjb3VudF9uYW1lBG5hbWULYWN0aW9uX25hbWUNYXV0aG9yaXphdGlvbhJwZXJtaXNzaW9uX2xldmVsW10EZGF0YQVieXRlcxJ0cmFuc2FjdGlvbl9oZWFkZXIABgpleHBpcmF0aW9uDnRpbWVfcG9pbnRfc2VjDXJlZl9ibG9ja19udW0GdWludDE2EHJlZl9ibG9ja19wcmVmaXgGdWludDMyE21heF9uZXRfdXNhZ2Vfd29yZHMJdmFydWludDMyEG1heF9jcHVfdXNhZ2VfbXMFdWludDgJZGVsYXlfc2VjCXZhcnVpbnQzMglleHRlbnNpb24AAgR0eXBlBnVpbnQxNgRkYXRhBWJ5dGVzC3RyYW5zYWN0aW9uEnRyYW5zYWN0aW9uX2hlYWRlcgMUY29udGV4dF9mcmVlX2FjdGlvbnMIYWN0aW9uW10HYWN0aW9ucwhhY3Rpb25bXRZ0cmFuc2FjdGlvbl9leHRlbnNpb25zC2V4dGVuc2lvbltdB3Byb3Bvc2UABAhwcm9wb3NlcgxhY2NvdW50X25hbWUNcHJvcG9zYWxfbmFtZQRuYW1lCXJlcXVlc3RlZBJwZXJtaXNzaW9uX2xldmVsW10DdHJ4C3RyYW5zYWN0aW9uB2FwcHJvdmUAAwhwcm9wb3NlcgxhY2NvdW50X25hbWUNcHJvcG9zYWxfbmFtZQRuYW1lBWxldmVsEHBlcm1pc3Npb25fbGV2ZWwJdW5hcHByb3ZlAAMIcHJvcG9zZXIMYWNjb3VudF9uYW1lDXByb3Bvc2FsX25hbWUEbmFtZQVsZXZlbBBwZXJtaXNzaW9uX2xldmVsBmNhbmNlbAADCHByb3Bvc2VyDGFjY291bnRfbmFtZQ1wcm9wb3NhbF9uYW1lBG5hbWUIY2FuY2VsZXIMYWNjb3VudF9uYW1lBGV4ZWMAAwhwcm9wb3NlcgxhY2NvdW50X25hbWUNcHJvcG9zYWxfbmFtZQRuYW1lCGV4ZWN1dGVyDGFjY291bnRfbmFtZQhwcm9wb3NhbAACDXByb3Bvc2FsX25hbWUEbmFtZRJwYWNrZWRfdHJhbnNhY3Rpb24FYnl0ZXMOYXBwcm92YWxzX2luZm8AAw1wcm9wb3NhbF9uYW1lBG5hbWUTcmVxdWVzdGVkX2FwcHJvdmFscxJwZXJtaXNzaW9uX2xldmVsW10ScHJvdmlkZWRfYXBwcm92YWxzEnBlcm1pc3Npb25fbGV2ZWxbXQUAAABAYVrprQdwcm9wb3NlAAAAAEBtems1B2FwcHJvdmUAAABQm95azdQJdW5hcHByb3ZlAAAAAABEhaZBBmNhbmNlbAAAAAAAAIBUVwRleGVjAAIAAADRYFrprQNpNjQBDXByb3Bvc2FsX25hbWUBBG5hbWUIcHJvcG9zYWwAAMDRbHprNQNpNjQBDXByb3Bvc2FsX25hbWUBBG5hbWUOYXBwcm92YWxzX2luZm8AAAAA="

    let msigAbiHex = "0e656f73696f3a3a6162692f312e30030c6163636f756e745f6e616d65046e616d650f7065726d697373696f6e5f6e616d65046e616d650b616374696f6e5f6e616d65046e616d650c107065726d697373696f6e5f6c6576656c0002056163746f720c6163636f756e745f6e616d650a7065726d697373696f6e0f7065726d697373696f6e5f6e616d6506616374696f6e0004076163636f756e740c6163636f756e745f6e616d65046e616d650b616374696f6e5f6e616d650d617574686f72697a6174696f6e127065726d697373696f6e5f6c6576656c5b5d0464617461056279746573127472616e73616374696f6e5f68656164657200060a65787069726174696f6e0e74696d655f706f696e745f7365630d7265665f626c6f636b5f6e756d0675696e743136107265665f626c6f636b5f7072656669780675696e743332136d61785f6e65745f75736167655f776f7264730976617275696e743332106d61785f6370755f75736167655f6d730575696e74380964656c61795f7365630976617275696e74333209657874656e73696f6e000204747970650675696e74313604646174610562797465730b7472616e73616374696f6e127472616e73616374696f6e5f6865616465720314636f6e746578745f667265655f616374696f6e7308616374696f6e5b5d07616374696f6e7308616374696f6e5b5d167472616e73616374696f6e5f657874656e73696f6e730b657874656e73696f6e5b5d0770726f706f736500040870726f706f7365720c6163636f756e745f6e616d650d70726f706f73616c5f6e616d65046e616d6509726571756573746564127065726d697373696f6e5f6c6576656c5b5d037472780b7472616e73616374696f6e07617070726f766500030870726f706f7365720c6163636f756e745f6e616d650d70726f706f73616c5f6e616d65046e616d65056c6576656c107065726d697373696f6e5f6c6576656c09756e617070726f766500030870726f706f7365720c6163636f756e745f6e616d650d70726f706f73616c5f6e616d65046e616d65056c6576656c107065726d697373696f6e5f6c6576656c0663616e63656c00030870726f706f7365720c6163636f756e745f6e616d650d70726f706f73616c5f6e616d65046e616d650863616e63656c65720c6163636f756e745f6e616d65046578656300030870726f706f7365720c6163636f756e745f6e616d650d70726f706f73616c5f6e616d65046e616d650865786563757465720c6163636f756e745f6e616d650870726f706f73616c00020d70726f706f73616c5f6e616d65046e616d65127061636b65645f7472616e73616374696f6e0562797465730e617070726f76616c735f696e666f00030d70726f706f73616c5f6e616d65046e616d65137265717565737465645f617070726f76616c73127065726d697373696f6e5f6c6576656c5b5d1270726f76696465645f617070726f76616c73127065726d697373696f6e5f6c6576656c5b5d0500000040615ae9ad0770726f706f736500000000406d7a6b3507617070726f7665000000509bde5acdd409756e617070726f766500000000004485a6410663616e63656c00000000000080545704657865630002000000d1605ae9ad03693634010d70726f706f73616c5f6e616d6501046e616d650870726f706f73616c0000c0d16c7a6b3503693634010d70726f706f73616c5f6e616d6501046e616d650e617070726f76616c735f696e666f00000000"

    let eosioAbiB64 = "DmVvc2lvOjphYmkvMS4xADYIYWJpX2hhc2gAAgVvd25lcgRuYW1lBGhhc2gLY2hlY2tzdW0yNTYJYXV0aG9yaXR5AAQJdGhyZXNob2xkBnVpbnQzMgRrZXlzDGtleV93ZWlnaHRbXQhhY2NvdW50cxlwZXJtaXNzaW9uX2xldmVsX3dlaWdodFtdBXdhaXRzDXdhaXRfd2VpZ2h0W10KYmlkX3JlZnVuZAACBmJpZGRlcgRuYW1lBmFtb3VudAVhc3NldAdiaWRuYW1lAAMGYmlkZGVyBG5hbWUHbmV3bmFtZQRuYW1lA2JpZAVhc3NldAliaWRyZWZ1bmQAAgZiaWRkZXIEbmFtZQduZXduYW1lBG5hbWUMYmxvY2tfaGVhZGVyAAgJdGltZXN0YW1wBnVpbnQzMghwcm9kdWNlcgRuYW1lCWNvbmZpcm1lZAZ1aW50MTYIcHJldmlvdXMLY2hlY2tzdW0yNTYRdHJhbnNhY3Rpb25fbXJvb3QLY2hlY2tzdW0yNTYMYWN0aW9uX21yb290C2NoZWNrc3VtMjU2EHNjaGVkdWxlX3ZlcnNpb24GdWludDMyDW5ld19wcm9kdWNlcnMScHJvZHVjZXJfc2NoZWR1bGU/FWJsb2NrY2hhaW5fcGFyYW1ldGVycwARE21heF9ibG9ja19uZXRfdXNhZ2UGdWludDY0GnRhcmdldF9ibG9ja19uZXRfdXNhZ2VfcGN0BnVpbnQzMhltYXhfdHJhbnNhY3Rpb25fbmV0X3VzYWdlBnVpbnQzMh5iYXNlX3Blcl90cmFuc2FjdGlvbl9uZXRfdXNhZ2UGdWludDMyEG5ldF91c2FnZV9sZWV3YXkGdWludDMyI2NvbnRleHRfZnJlZV9kaXNjb3VudF9uZXRfdXNhZ2VfbnVtBnVpbnQzMiNjb250ZXh0X2ZyZWVfZGlzY291bnRfbmV0X3VzYWdlX2RlbgZ1aW50MzITbWF4X2Jsb2NrX2NwdV91c2FnZQZ1aW50MzIadGFyZ2V0X2Jsb2NrX2NwdV91c2FnZV9wY3QGdWludDMyGW1heF90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGW1pbl90cmFuc2FjdGlvbl9jcHVfdXNhZ2UGdWludDMyGG1heF90cmFuc2FjdGlvbl9saWZldGltZQZ1aW50MzIeZGVmZXJyZWRfdHJ4X2V4cGlyYXRpb25fd2luZG93BnVpbnQzMhVtYXhfdHJhbnNhY3Rpb25fZGVsYXkGdWludDMyFm1heF9pbmxpbmVfYWN0aW9uX3NpemUGdWludDMyF21heF9pbmxpbmVfYWN0aW9uX2RlcHRoBnVpbnQxNhNtYXhfYXV0aG9yaXR5X2RlcHRoBnVpbnQxNgZidXlyYW0AAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFcXVhbnQFYXNzZXQLYnV5cmFtYnl0ZXMAAwVwYXllcgRuYW1lCHJlY2VpdmVyBG5hbWUFYnl0ZXMGdWludDMyC2NhbmNlbGRlbGF5AAIOY2FuY2VsaW5nX2F1dGgQcGVybWlzc2lvbl9sZXZlbAZ0cnhfaWQLY2hlY2tzdW0yNTYMY2xhaW1yZXdhcmRzAAEFb3duZXIEbmFtZQljb25uZWN0b3IAAgdiYWxhbmNlBWFzc2V0BndlaWdodAdmbG9hdDY0CmRlbGVnYXRlYncABQRmcm9tBG5hbWUIcmVjZWl2ZXIEbmFtZRJzdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQSc3Rha2VfY3B1X3F1YW50aXR5BWFzc2V0CHRyYW5zZmVyBGJvb2wTZGVsZWdhdGVkX2JhbmR3aWR0aAAEBGZyb20EbmFtZQJ0bwRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldApkZWxldGVhdXRoAAIHYWNjb3VudARuYW1lCnBlcm1pc3Npb24EbmFtZRJlb3Npb19nbG9iYWxfc3RhdGUVYmxvY2tjaGFpbl9wYXJhbWV0ZXJzDQxtYXhfcmFtX3NpemUGdWludDY0GHRvdGFsX3JhbV9ieXRlc19yZXNlcnZlZAZ1aW50NjQPdG90YWxfcmFtX3N0YWtlBWludDY0HWxhc3RfcHJvZHVjZXJfc2NoZWR1bGVfdXBkYXRlFGJsb2NrX3RpbWVzdGFtcF90eXBlGGxhc3RfcGVydm90ZV9idWNrZXRfZmlsbAp0aW1lX3BvaW50DnBlcnZvdGVfYnVja2V0BWludDY0D3BlcmJsb2NrX2J1Y2tldAVpbnQ2NBN0b3RhbF91bnBhaWRfYmxvY2tzBnVpbnQzMhV0b3RhbF9hY3RpdmF0ZWRfc3Rha2UFaW50NjQbdGhyZXNoX2FjdGl2YXRlZF9zdGFrZV90aW1lCnRpbWVfcG9pbnQbbGFzdF9wcm9kdWNlcl9zY2hlZHVsZV9zaXplBnVpbnQxNhp0b3RhbF9wcm9kdWNlcl92b3RlX3dlaWdodAdmbG9hdDY0D2xhc3RfbmFtZV9jbG9zZRRibG9ja190aW1lc3RhbXBfdHlwZRNlb3Npb19nbG9iYWxfc3RhdGUyAAURbmV3X3JhbV9wZXJfYmxvY2sGdWludDE2EWxhc3RfcmFtX2luY3JlYXNlFGJsb2NrX3RpbWVzdGFtcF90eXBlDmxhc3RfYmxvY2tfbnVtFGJsb2NrX3RpbWVzdGFtcF90eXBlHHRvdGFsX3Byb2R1Y2VyX3ZvdGVwYXlfc2hhcmUHZmxvYXQ2NAhyZXZpc2lvbgV1aW50OBNlb3Npb19nbG9iYWxfc3RhdGUzAAIWbGFzdF92cGF5X3N0YXRlX3VwZGF0ZQp0aW1lX3BvaW50HHRvdGFsX3ZwYXlfc2hhcmVfY2hhbmdlX3JhdGUHZmxvYXQ2NA5leGNoYW5nZV9zdGF0ZQADBnN1cHBseQVhc3NldARiYXNlCWNvbm5lY3RvcgVxdW90ZQljb25uZWN0b3IEaW5pdAACB3ZlcnNpb24JdmFydWludDMyBGNvcmUGc3ltYm9sCmtleV93ZWlnaHQAAgNrZXkKcHVibGljX2tleQZ3ZWlnaHQGdWludDE2CGxpbmthdXRoAAQHYWNjb3VudARuYW1lBGNvZGUEbmFtZQR0eXBlBG5hbWULcmVxdWlyZW1lbnQEbmFtZQhuYW1lX2JpZAAEB25ld25hbWUEbmFtZQtoaWdoX2JpZGRlcgRuYW1lCGhpZ2hfYmlkBWludDY0DWxhc3RfYmlkX3RpbWUKdGltZV9wb2ludApuZXdhY2NvdW50AAQHY3JlYXRvcgRuYW1lBG5hbWUEbmFtZQVvd25lcglhdXRob3JpdHkGYWN0aXZlCWF1dGhvcml0eQdvbmJsb2NrAAEGaGVhZGVyDGJsb2NrX2hlYWRlcgdvbmVycm9yAAIJc2VuZGVyX2lkB3VpbnQxMjgIc2VudF90cngFYnl0ZXMQcGVybWlzc2lvbl9sZXZlbAACBWFjdG9yBG5hbWUKcGVybWlzc2lvbgRuYW1lF3Blcm1pc3Npb25fbGV2ZWxfd2VpZ2h0AAIKcGVybWlzc2lvbhBwZXJtaXNzaW9uX2xldmVsBndlaWdodAZ1aW50MTYNcHJvZHVjZXJfaW5mbwAIBW93bmVyBG5hbWULdG90YWxfdm90ZXMHZmxvYXQ2NAxwcm9kdWNlcl9rZXkKcHVibGljX2tleQlpc19hY3RpdmUEYm9vbAN1cmwGc3RyaW5nDXVucGFpZF9ibG9ja3MGdWludDMyD2xhc3RfY2xhaW1fdGltZQp0aW1lX3BvaW50CGxvY2F0aW9uBnVpbnQxNg5wcm9kdWNlcl9pbmZvMgADBW93bmVyBG5hbWUNdm90ZXBheV9zaGFyZQdmbG9hdDY0GWxhc3Rfdm90ZXBheV9zaGFyZV91cGRhdGUKdGltZV9wb2ludAxwcm9kdWNlcl9rZXkAAg1wcm9kdWNlcl9uYW1lBG5hbWURYmxvY2tfc2lnbmluZ19rZXkKcHVibGljX2tleRFwcm9kdWNlcl9zY2hlZHVsZQACB3ZlcnNpb24GdWludDMyCXByb2R1Y2Vycw5wcm9kdWNlcl9rZXlbXQZyZWZ1bmQAAQVvd25lcgRuYW1lDnJlZnVuZF9yZXF1ZXN0AAQFb3duZXIEbmFtZQxyZXF1ZXN0X3RpbWUOdGltZV9wb2ludF9zZWMKbmV0X2Ftb3VudAVhc3NldApjcHVfYW1vdW50BWFzc2V0C3JlZ3Byb2R1Y2VyAAQIcHJvZHVjZXIEbmFtZQxwcm9kdWNlcl9rZXkKcHVibGljX2tleQN1cmwGc3RyaW5nCGxvY2F0aW9uBnVpbnQxNghyZWdwcm94eQACBXByb3h5BG5hbWUHaXNwcm94eQRib29sC3JtdnByb2R1Y2VyAAEIcHJvZHVjZXIEbmFtZQdzZWxscmFtAAIHYWNjb3VudARuYW1lBWJ5dGVzBWludDY0BnNldGFiaQACB2FjY291bnQEbmFtZQNhYmkFYnl0ZXMKc2V0YWxpbWl0cwAEB2FjY291bnQEbmFtZQlyYW1fYnl0ZXMFaW50NjQKbmV0X3dlaWdodAVpbnQ2NApjcHVfd2VpZ2h0BWludDY0B3NldGNvZGUABAdhY2NvdW50BG5hbWUGdm10eXBlBXVpbnQ4CXZtdmVyc2lvbgV1aW50OARjb2RlBWJ5dGVzCXNldHBhcmFtcwABBnBhcmFtcxVibG9ja2NoYWluX3BhcmFtZXRlcnMHc2V0cHJpdgACB2FjY291bnQEbmFtZQdpc19wcml2BXVpbnQ4BnNldHJhbQABDG1heF9yYW1fc2l6ZQZ1aW50NjQKc2V0cmFtcmF0ZQABD2J5dGVzX3Blcl9ibG9jawZ1aW50MTYMdW5kZWxlZ2F0ZWJ3AAQEZnJvbQRuYW1lCHJlY2VpdmVyBG5hbWUUdW5zdGFrZV9uZXRfcXVhbnRpdHkFYXNzZXQUdW5zdGFrZV9jcHVfcXVhbnRpdHkFYXNzZXQKdW5saW5rYXV0aAADB2FjY291bnQEbmFtZQRjb2RlBG5hbWUEdHlwZQRuYW1lCXVucmVncHJvZAABCHByb2R1Y2VyBG5hbWUKdXBkYXRlYXV0aAAEB2FjY291bnQEbmFtZQpwZXJtaXNzaW9uBG5hbWUGcGFyZW50BG5hbWUEYXV0aAlhdXRob3JpdHkMdXBkdHJldmlzaW9uAAEIcmV2aXNpb24FdWludDgOdXNlcl9yZXNvdXJjZXMABAVvd25lcgRuYW1lCm5ldF93ZWlnaHQFYXNzZXQKY3B1X3dlaWdodAVhc3NldAlyYW1fYnl0ZXMFaW50NjQMdm90ZXByb2R1Y2VyAAMFdm90ZXIEbmFtZQVwcm94eQRuYW1lCXByb2R1Y2VycwZuYW1lW10Kdm90ZXJfaW5mbwAKBW93bmVyBG5hbWUFcHJveHkEbmFtZQlwcm9kdWNlcnMGbmFtZVtdBnN0YWtlZAVpbnQ2NBBsYXN0X3ZvdGVfd2VpZ2h0B2Zsb2F0NjQTcHJveGllZF92b3RlX3dlaWdodAdmbG9hdDY0CGlzX3Byb3h5BGJvb2wJcmVzZXJ2ZWQxBnVpbnQzMglyZXNlcnZlZDIGdWludDMyCXJlc2VydmVkMwVhc3NldAt3YWl0X3dlaWdodAACCHdhaXRfc2VjBnVpbnQzMgZ3ZWlnaHQGdWludDE2HwAAAEBJM5M7B2JpZG5hbWUAAABIUy91kzsJYmlkcmVmdW5kAAAAAABIc70+BmJ1eXJhbQAAsMr+SHO9PgtidXlyYW1ieXRlcwAAvIkqRYWmQQtjYW5jZWxkZWxheQCA0zVcXelMRAxjbGFpbXJld2FyZHMAAAA/KhumokoKZGVsZWdhdGVidwAAQMvaqKyiSgpkZWxldGVhdXRoAAAAAAAAkN10BGluaXQAAAAALWsDp4sIbGlua2F1dGgAAECemiJkuJoKbmV3YWNjb3VudAAAAAAAIhrPpAdvbmJsb2NrAAAAAODSe9WkB29uZXJyb3IAAAAAAKSpl7oGcmVmdW5kAACuQjrRW5m6C3JlZ3Byb2R1Y2VyAAAAAL7TW5m6CHJlZ3Byb3h5AACuQjrRW7e8C3JtdnByb2R1Y2VyAAAAAECaG6PCB3NlbGxyYW0AAAAAALhjssIGc2V0YWJpAAAAzk66aLLCCnNldGFsaW1pdHMAAAAAQCWKssIHc2V0Y29kZQAAAMDSXFOzwglzZXRwYXJhbXMAAAAAYLtbs8IHc2V0cHJpdgAAAAAASHOzwgZzZXRyYW0AAIDK5kpzs8IKc2V0cmFtcmF0ZQDAj8qGqajS1Ax1bmRlbGVnYXRlYncAAEDL2sDp4tQKdW5saW5rYXV0aAAAAEj0Vqbu1Al1bnJlZ3Byb2QAAEDL2qhsUtUKdXBkYXRlYXV0aAAwqcNuq5tT1Qx1cGR0cmV2aXNpb24AcBXSid6qMt0Mdm90ZXByb2R1Y2VyAA0AAACgYdPcMQNpNjQAAAhhYmlfaGFzaAAATlMvdZM7A2k2NAAACmJpZF9yZWZ1bmQAAAAgTXOiSgNpNjQAABNkZWxlZ2F0ZWRfYmFuZHdpZHRoAAAAAERzaGQDaTY0AAASZW9zaW9fZ2xvYmFsX3N0YXRlAAAAQERzaGQDaTY0AAATZW9zaW9fZ2xvYmFsX3N0YXRlMgAAAGBEc2hkA2k2NAAAE2Vvc2lvX2dsb2JhbF9zdGF0ZTMAAAA4uaOkmQNpNjQAAAhuYW1lX2JpZAAAwFchneitA2k2NAAADXByb2R1Y2VyX2luZm8AgMBXIZ3orQNpNjQAAA5wcm9kdWNlcl9pbmZvMgAAyApeI6W5A2k2NAAADmV4Y2hhbmdlX3N0YXRlAAAAAKepl7oDaTY0AAAOcmVmdW5kX3JlcXVlc3QAAAAAq3sV1gNpNjQAAA51c2VyX3Jlc291cmNlcwAAAADgqzLdA2k2NAAACnZvdGVyX2luZm8AAAAA="

}
